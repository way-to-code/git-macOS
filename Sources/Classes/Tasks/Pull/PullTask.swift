//
//  GitPushOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class PullTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "pull"
    }
    
    func handle(output: String) {
        repository.delegate?.repository(repository, didProgressPull: output)
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            throw GitError.pullError(message: output ?? "")
        }
    }
}
