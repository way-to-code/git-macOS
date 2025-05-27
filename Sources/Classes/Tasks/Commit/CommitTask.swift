//
//  CommitTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class CommitTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "commit"
    }
    
    func handle(output: String) {
        repository.delegate?.repository(repository, didProgressCommit: output)
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as a commit was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.commitError(message: output)
        }
    }
}
