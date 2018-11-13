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

import Cocoa

protocol ProcessListenerDelegate: class {
    func listener(_ listener: ProcessListener, didReceiveData data: String)
    func listenerDidFinish(_ listener: ProcessListener)
}

class ProcessListener {
    
    // MARK: - Public
    /// Describes a type of a listener
    enum StreamType: String {
        case standart
        case error
    }
    
    enum State {
        case idle
        case running
        case finished
        
        fileprivate mutating func proceedToRunning() {
            guard self == .idle else {
                return
            }
            
            self = .running
        }
        
        fileprivate mutating func proceedToFinished() {
            guard self == .running else {
                return
            }
            
            self = .finished
        }
    }
    
    private(set) var state: State = .idle
    weak var delegate: ProcessListenerDelegate?
    
    required init(process: Process, type: StreamType) {
        self.process = process
        self.type = type
        
        pipe = Pipe()
        pipe.fileHandleForReading.readabilityHandler = { [weak self] pipe in
            self?.processStream(using: pipe)
        }
    }
    
    /// Starts listening process in background
    func startListening() {
        switch type {
        case .standart:
            process?.standardOutput = pipe
        case .error:
            process?.standardError = pipe
        }
        
        listen(for: pipe.fileHandleForReading)
    }
    
    func stopListening() {
        pipe.fileHandleForReading.readabilityHandler = nil
    }

    // MARK: - Private
    private var pipe: Pipe
    private var type: StreamType
    private weak var process: Process?
    
    /// Indicates whether a process is active or not
    private var isProcessRunning: Bool {
        return process?.isRunning ?? false
    }
    
    private func listen(for pipe: FileHandle) {
        // 1. It is important to call waitForDataInBackgroundAndNotify in a thread that have an active run loop;
        // 2. Also we have to use sync instead of async, because in case of async pipe may become inconsistent after a new cycle of the current run loop;
        if Thread.isMainThread {
            pipe.waitForDataInBackgroundAndNotify()
        } else {
            DispatchQueue.main.sync {
                pipe.waitForDataInBackgroundAndNotify()
            }
        }
    }
    
    private func processStream(using pipe: FileHandle) {
        state.proceedToRunning()
        let reiceivedData = String(data: pipe.availableData, encoding: String.Encoding.utf8) ?? ""
        
        if reiceivedData.count == 0 {
            if isProcessRunning {
                // continue listening
                listen(for: pipe)
            } else if state == .running {
                state.proceedToFinished()
                delegate?.listenerDidFinish(self)
            }

            return
        }
        
        delegate?.listener(self, didReceiveData: reiceivedData)
        listen(for: pipe)
    }
}
