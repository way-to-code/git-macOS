//
//  ProcessTask.swift
//  Git-macOS
//
//  Copyright (c) 2018 Max A. Akhmatov
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

protocol ProcessTaskDelegate: class {
    
    /// Is called each time a new update received from the process. The method is always called in the main thread
    ///
    /// - Parameters:
    ///   - task: A task that raised an event
    ///   - output: An output string from the involved process
    func task(_ task: ProcessTask, didReceiveOutput output: String)
    
    /// Is called each time a new error update received from the process. The method is always called in the main thread
    ///
    /// - Parameters:
    ///   - task: A task that raised an event
    ///   - output: An error output string from the involved process
    func task(_ task: ProcessTask, didReceiveErrorOutput errorOutput: String)
    
    /// Is called when a task is fully finished. The method is always called in the main thread
    ///
    /// - Parameters:
    ///   - task: A task that raised an event
    ///   - terminationCode: A termination code where 0 (zero) indicates the successful execution
    func task(_ task: ProcessTask, didFinishWithTerminationCode terminationCode: Int32)
}

class ProcessTask {
    
    // MARK: - Private (Properties)
    private var runLoop: CFRunLoop!

    private var process: Process!
    private var standartStream: ProcessListener!
    private var errorStream: ProcessListener!
    
    private(set) var output = ""
    private(set) var errorOutput = ""

    private var _isFinished: Bool = false
    private let isFinishedLockQueue = DispatchQueue(label: "ProcessTask.isFinished.lock")
    
    private var isFinished: Bool {
        get {
            return isFinishedLockQueue.sync {
                return _isFinished
            }
        }
        
        set {
            isFinishedLockQueue.sync {
                _isFinished = newValue
            }
        }
    }
    
    private var outputStreamGroup = DispatchGroup()
    private var errorOutputStreamGroup = DispatchGroup()
    
    // MARK: - Public (Init)
    weak var delegate: ProcessTaskDelegate?
    
    init(arguments: [String]) {
        process = createProcess()
        process.arguments = arguments
        
        standartStream = ProcessListener(process: process, type: .standart)
        errorStream = ProcessListener(process: process, type: .error)
        
        standartStream.delegate = self
        errorStream.delegate = self
    }
    
    // MARK: - Public
    func run(workingPath: String? = nil) {
        if let workingPath = workingPath {
            process.currentDirectoryURL = URL(fileURLWithPath: workingPath)
        }
        
        outputStreamGroup.enter()
        errorOutputStreamGroup.enter()
        
        process.terminationHandler = commandTerminationHandler
        
        standartStream.startListening()
        errorStream.startListening()
        
        // before the process is started, obtain a reference to the current run loop
        runLoop = CFRunLoopGetCurrent()
        guard runLoop != nil else {
            errorOutput = "Internal problem has occured. If you see this issue, please file a bug to the github page of Git.framework. Error details: unable to obtain a reference to the current run loop on thread \(Thread.current)"
            return
        }
        
        do {
            try process.run()
        }
        catch {
            errorOutput = error.localizedDescription
            return
        }

        // a task might be already finished at this time, ensure if waiting is required
        guard !isFinished else { return }
        
        // wait until task is completed and streams are finished
        if runLoop != nil {
            CFRunLoopRun()
        }
    }
    
    func cancel() {
        process.interrupt()
        process.terminate()
        standartStream.stopListening()
        errorStream.stopListening()
    }
    
    func terminationStatus() -> Int32 {
        guard isFinished else {
            return -1
        }
        
        return process.terminationStatus
    }
    
    // MARK: - Private (Internal)

    private func createProcess() -> Process {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        
        return process
    }
    
    private func commandTerminationHandler(task: Process) {
        // give a chance for streams to finish processing
        outputStreamGroup.wait()
        errorOutputStreamGroup.wait()
    
        isFinished = true

        // finish streams
        standartStream.stopListening()
        errorStream.stopListening()
        
        DispatchQueue.main.async {
            self.delegate?.task(self, didFinishWithTerminationCode: self.terminationStatus())
        }
        
        CFRunLoopStop(runLoop)
        runLoop = nil
    }
}

// MARK: - ProcessListenerDelegate
extension ProcessTask: ProcessListenerDelegate {
    func listener(_ listener: ProcessListener, didReceiveData data: String) {
        if listener === standartStream {
            output += data
            DispatchQueue.main.async {
                self.delegate?.task(self, didReceiveOutput: data)
            }
        } else if listener === errorStream {
            errorOutput += data
            DispatchQueue.main.async {
                self.delegate?.task(self, didReceiveErrorOutput: data)
            }
        }
    }
    
    func listenerDidFinish(_ listener: ProcessListener) {
        if listener === standartStream {
            outputStreamGroup.leave()
        } else if listener === errorStream {
            errorOutputStreamGroup.leave()
        }
    }
}
