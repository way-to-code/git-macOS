//
//  CloneTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class CloneTask: RepositoryTask, TaskRequirable {
    
    required init(toLocalPath localPath: String,
                  fromRemotePath remotePath: String,
                  owner: GitRepository,
                  options: GitCloneOptions) {
        super.init(owner: owner, options: [])
        
        add([remotePath, localPath])
        add(options.toArguments())
    }

    // MARK: - TaskRequirable
    var name: String {
        return "clone"
    }
    
    func handle(output: String) {
        repository.delegate?.repository(repository, didProgressClone: output)
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as the clone was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.cloneError(message: output)
        }
    }
}
