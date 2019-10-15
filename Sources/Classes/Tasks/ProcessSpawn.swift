//
//  ProcessSpawn.swift
//  Git-macOS
//
//  Copyright (c) 2019 Max A. Akhmatov
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

#if os(OSX)
import Darwin.C
#else
import Glibc
#endif

/// Describes an error that can be raised by posix-spawn operation
///
/// - canNotOpenPipe: A pipe can not be opened for reading. Indicates an internal error.
/// - canNotCreatePosixSpawn: A posix spawn was not succeeded. Indicated an internal error.
public enum SpawnError: Error {
    case canNotOpenPipe(text: String, code: Int32)
    case canNotCreatePosixSpawn
}

extension SpawnError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .canNotOpenPipe(let message, let code):
            return "Can not create a new pipe for reading. Error says: '\(message)'. Error code \(code)"
        case .canNotCreatePosixSpawn:
            return "Unable to posix_spawn. Aborted"
        }
    }
}

public typealias OutputClosure = (String) -> Void
public typealias OutputCompletionClosure = () -> Void

final class ProcessSpawn {
    
    private static var bufferSize = 1024 * 8
    
    /// The arguments to be executed.
    let args: [String]
    
    /// Closure to be executed when there is
    /// some data on stdout/stderr streams.
    private var output: OutputClosure?
    
    /// The PID of the child process.
    private(set) var pid: pid_t = 0
    
    /// Process terminatation status
    private(set) var terminationStatus: Int32 = 0
    
    /// Determines a process id created by this process
    private(set) var processId: Int32
    
    /// The TID of the thread which will read streams.
    #if os(OSX)
    private(set) var tid: pthread_t? = nil
    private var childFDActions: posix_spawn_file_actions_t? = nil
    #else
    private(set) var tid = pthread_t()
    private var childFDActions = posix_spawn_file_actions_t()
    #endif
    
    /// Payload information to be passed to a posix thread
    private struct Payload {
        let outputPipe: UnsafeMutablePointer<Int32>
        let output: OutputClosure?
        let pid: pid_t
        
        var isCancelled = false
    }
    
    private var threadPayload: Payload!
    private let workingPath: String?
    
    /// Pipes: 0 - for reading, 1: - for writing
    private var outputPipe: [Int32] = [-1, -1]
    
    public init(args: [String], envs: [String], workingPath: String?, output: OutputClosure? = nil) throws {
        (self.args, self.output, self.workingPath)  = (args, output, workingPath)
        
        if pipe(&outputPipe) < 0 {
            if let message = strerror(errno) {
                throw SpawnError.canNotOpenPipe(text: String(cString: message), code: errno)
            } else {
                throw SpawnError.canNotOpenPipe(text: "Undefined error", code: errno)
            }
        }
        
        posix_spawn_file_actions_init(&childFDActions)
        posix_spawn_file_actions_adddup2(&childFDActions, outputPipe[1], 1)
        posix_spawn_file_actions_adddup2(&childFDActions, outputPipe[1], 2)
        posix_spawn_file_actions_addclose(&childFDActions, outputPipe[0])
        posix_spawn_file_actions_addclose(&childFDActions, outputPipe[1])
        
        let argv: [UnsafeMutablePointer<CChar>?] = args.map{ $0.withCString(strdup) }
        var envp: [UnsafeMutablePointer<CChar>?] = envs.map{ $0.withCString(strdup) }
        defer { for case let arg? in argv { free(arg) } }
        defer { for case let env? in envp { free(env) } }
        
        guard posix_spawn(&pid, argv[0], &childFDActions, nil, argv + [nil], envp + [nil]) >= 0 else {
            throw SpawnError.canNotCreatePosixSpawn
        }
        
        processId = pid
        readStream()
        terminationStatus = waitSpawn(pid: pid)
    }
    
    func cancel() {
        threadPayload?.isCancelled = true
        
        if let threadId = tid {
            pthread_cancel(threadId)
        }
    }
    
    private func WIFEXITED(_ status: Int32) -> Bool {
        return _WSTATUS(status) == 0
    }
    
    private func _WSTATUS(_ status: Int32) -> Int32 {
        return status & 0x7f
    }
    
    private func WEXITSTATUS(_ status: Int32) -> Int32 {
        return (status >> 8) & 0xff
    }
    
    private func WTERMSIG(_ status: Int32) -> Int32 {
        return status & 0x7f
    }
    
    private func WIFSIGNALED(_ status: Int32) -> Bool {
        return (_WSTATUS(status) != 0) && (_WSTATUS(status) != 0x7f)
    }
    
    private func waitSpawn(pid: pid_t) -> Int32 {
        var status: CInt = 0
        
        while waitpid(pid, &status, 0) < 0 {
            if errno != EINTR {
                preconditionFailure("waitpid() failed")
            }
        }
        
        if WIFEXITED(status) {
            return WEXITSTATUS(status)
        }
        
        if WIFSIGNALED(status) {
            return WTERMSIG(status)
        }
        
        return -1
    }
    
    func readStream() {
        func callback(x: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
            let payload = x.assumingMemoryBound(to: Payload.self).pointee
            let outputPipe = payload.outputPipe
            close(outputPipe[1])
            
            let bufferSize: size_t = ProcessSpawn.bufferSize
            let dynamicBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            defer { dynamicBuffer.deallocate() }
            
            while !payload.isCancelled {
                let readBytes = read(outputPipe[0], dynamicBuffer, bufferSize)
                guard readBytes > 0 else { break }
                
                let array = Array(UnsafeBufferPointer(start: dynamicBuffer, count: readBytes))
                let tmp = array  + [UInt8(0)]
                tmp.withUnsafeBufferPointer { ptr in
                    let data = String(cString: unsafeBitCast(ptr.baseAddress, to: UnsafePointer<CChar>.self))
                    payload.output?(data)
                }
            }
            
            close(outputPipe[0])
            return nil
        }
        
        threadPayload = Payload(outputPipe: &outputPipe, output: output, pid: pid, isCancelled: false)
        pthread_create(&tid, nil, callback, &threadPayload)
        
        if let tid = tid {
            // Wait for the thread to be executed
            pthread_join(tid, nil)
        }
    }
}
