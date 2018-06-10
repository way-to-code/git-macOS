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
    private var pipe = Pipe()
    private var errorPipe = Pipe()
    private var process: Process!
    
    private(set) var output = ""
    private(set) var errorOutput = ""
    private(set) var isRunning = false

    // MARK: - Public (Init)
    weak var delegate: ProcessTaskDelegate?
    
    init(arguments: [String]) {
        process = createProcess()
        process.arguments = arguments
    }

    // MARK: - Public
    func run(workingPath: String? = nil) {
        isRunning = true
        
        if let workingPath = workingPath {
            process.currentDirectoryPath = workingPath
        }

        pipe.fileHandleForReading.readabilityHandler = { pipe in
            let reiceivedData = String(data: pipe.availableData, encoding: String.Encoding.utf8) ?? ""
            
            if reiceivedData.count == 0 {
                guard self.isRunning else { return }
                pipe.waitForDataInBackgroundAndNotify()
            }

            DispatchQueue.main.sync {
                self.delegate?.task(self, didReceiveOutput: reiceivedData)
            }
            self.output += reiceivedData
            pipe.waitForDataInBackgroundAndNotify()
        }
        
        errorPipe.fileHandleForReading.readabilityHandler = { pipe in
            let reiceivedData = String(data: pipe.availableData, encoding: String.Encoding.utf8) ?? ""
            
            if reiceivedData.count == 0 {
                guard self.isRunning else { return }
                pipe.waitForDataInBackgroundAndNotify()
            }
            
            DispatchQueue.main.sync {
                self.delegate?.task(self, didReceiveErrorOutput: reiceivedData)
            }
            
            self.errorOutput += reiceivedData
            pipe.waitForDataInBackgroundAndNotify()
        }

        process.terminationHandler = commandTerminationHandler

        process.launch()
        process.waitUntilExit()
    }
    
    func cancel() {
        process.terminate()
        pipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
    }
    
    func terminationStatus() -> Int32 {
        return process.terminationStatus
    }
    
    // MARK: - Private (Internal)
    private func createProcess() -> Process {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.standardOutput = pipe
        process.standardError = errorPipe
        
        return process
    }
    
    private func commandTerminationHandler(task: Process) {
        isRunning = false
        pipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        
        DispatchQueue.main.async {
            self.delegate?.task(self, didFinishWithTerminationCode: self.terminationStatus())
        }
    }
}
