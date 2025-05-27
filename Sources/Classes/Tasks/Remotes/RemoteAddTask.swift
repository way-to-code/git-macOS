//
//  RemoteAddTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class RemoteAddTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "remote"
    }
    
    required init(owner: GitRepository, name: String, url: URL) {
        super.init(owner: owner, options: [])

        add(["add", name, url.absoluteString])
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as the fetch was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.remoteUnableToAdd(message: output)
        }
    }
}
