//
//  FetchTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class FetchTask: RepositoryTask, TaskRequirable {
    
    var name: String { return "fetch" }
    
    func handle(output: String) {
        repository.delegate?.repository(repository, didProgressFetch: output)
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as the fetch was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.fetchError(message: output)
        }
    }
}
