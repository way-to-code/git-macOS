//
//  ArgumentConvertible.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class RemoteRenameTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "remote"
    }

    required init(owner: GitRepository, remote: GitRemote, name: String) {
        super.init(owner: owner, options: [])
        
        add(["rename", (remote.name), name])
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as an operation was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.remoteUnableToRename(message: output)
        }
    }
}
