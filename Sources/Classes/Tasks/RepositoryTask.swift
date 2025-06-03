//
//  RepositoryTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

protocol TaskRequirable: AnyObject {
    
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
    
    /// A path to git executable file on the disk
    static var executablePath = "/usr/bin/git"

    // MARK: - Private
    private(set) weak var repository: GitRepository!
    
    /// A git operation working directory
    var workingPath: String?
    
    /// A git operation parameters
    private(set) var parameters = [String]()
    
    /// A posix process for running a new git operation
    private var process: ProcessSpawn?
    
    /// The final task output received from a git operation
    private(set) var output: String?
    
    fileprivate weak var __self: TaskRequirable!
    
    /// MARK: - Public
    init(owner: GitRepository, options: ArgumentConvertible) {
         guard self is TaskRequirable else {
            fatalError("Task must conform to \(String(describing: TaskRequirable.self)) protocol, but it doesn't")
        }
        
        repository = owner
        repository.activeTask = self
        
        __self = self as? TaskRequirable
        
        workingPath = repository.localPath
        add(options.toArguments())
    }
    
    func add(_ arguments: [String]) {
        parameters.append(contentsOf: arguments)
    }
    
    final func run() throws {
        // prepare command line arguments
        var commandLine = [RepositoryTask.executablePath]
        
        if let path = workingPath {
            // Run as if git was started in <path>
            commandLine.append("-C")
            commandLine.append(path)
        }
        
        commandLine.append(__self.name)
        commandLine.append(contentsOf: parameters)
        
        // notify about a task 
        repository.delegate?.repository(repository, willStartTaskWithArguments: commandLine)
        
        var environmentVariables = [String]()
        
        // Git need to know $HOME environment variable
        if let home = getenv("HOME") {
            environmentVariables.append("HOME=\(String(cString:home))")
        }

        process = try ProcessSpawn(args: commandLine, envs: environmentVariables, workingPath: workingPath, output: { [weak self] (output) in
            if self?.output == nil {
                self?.output = ""
            }
            
            self?.output?.append(output)
            
            DispatchQueue.main.async {
                self?.__self.handle(output: output)
            }
        })
        
        try process?.run()
        
        guard let process = process else {
            try __self.finish(terminationStatus: -1)
            return
        }

        defer {
            // Clean up
            repository.activeTask = nil
        }
        
        try __self.finish(terminationStatus: process.terminationStatus)
    }
    
    final func cancel() {
        process?.cancel()
        process = nil
    }
}
