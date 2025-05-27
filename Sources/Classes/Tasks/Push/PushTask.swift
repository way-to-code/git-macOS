//
//  PushTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class PushTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "push"
    }
    
    func handle(output: String) {
        repository.delegate?.repository(repository, didProgressPush: output)
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as a commit was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.pushError(message: output)
        }
    }
}
