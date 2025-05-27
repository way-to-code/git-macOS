//
//  ArgumentConvertible.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class RemoteListTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "remote"
    }
    
    /// The list of remote names obtained by the operation
    private(set) var remoteNames = [String]()
    
    required init(owner: GitRepository) {
        super.init(owner: owner, options: [])
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as the fetch was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.remoteUnableToList(message: output)
        }
        
        // parse remotes. Each remote is divided by a new line
        let remotes = self.output?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
        
        for remoteName in remotes ?? [] {
            remoteNames.append(String(remoteName))
        }
    }
}
