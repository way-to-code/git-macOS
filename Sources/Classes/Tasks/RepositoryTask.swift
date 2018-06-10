//
//  RepositoryTask.swift
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

protocol TaskRequirable: class {
    
    /// A command name in repository
    var name: String { get }
    
    /// Method must handle an output received from command line
    func handle(output: String)
    
    /// Method must handle an error output received from command line
    func handle(errorOutput: String)
    
    /// Finishes task running and raises an exception if needed
    func finish(terminationStatus: Int32) throws
}

class RepositoryTask {

    // MARK: - Private
    private(set) var task: ProcessTask?
    private(set) weak var repository: GitRepository!
    
    var workingPath: String?
    private var parameters = [String]()
    fileprivate weak var __self: TaskRequirable!
    
    init(owner: GitRepository) {
        guard self is TaskRequirable else {
            fatalError("Task must conform to \(String(describing: TaskRequirable.self)) protocol, but it doesn't")
        }
        
        repository = owner
        repository.activeTask = self
        
        __self = self as? TaskRequirable
    }
    
    func add(_ arguments: [String]) {
        parameters.append(contentsOf: arguments)
    }
    
    final func run() throws {
        // prepare command line arguments
        var commandLine = ["git", __self.name]
        commandLine.append(contentsOf: parameters)
        
        // notify about a task 
        repository.delegate?.repository(repository, willStartTaskWithArguments: commandLine)
        
        let task = ProcessTask(arguments: commandLine)
        task.delegate = self
        self.task = task
        
        defer {
            // clear
            repository.activeTask = nil
        }

        // proceed with the task
        task.run(workingPath: workingPath)
        try __self.finish(terminationStatus: task.terminationStatus())
    }
    
    final func cancel() {
        task?.cancel()
        task = nil
    }
}

// MARK: - ProcessTaskDelegate
extension RepositoryTask: ProcessTaskDelegate {
    func task(_ task: ProcessTask, didReceiveOutput output: String) {
        __self.handle(output: output)
    }
    
    func task(_ task: ProcessTask, didReceiveErrorOutput errorOutput: String) {
        __self.handle(errorOutput: errorOutput)
    }
    
    func task(_ task: ProcessTask, didFinishWithTerminationCode terminationCode: Int32) {
    }
}
