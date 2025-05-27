//
//  RemoteUrlChangeTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class RemoteUrlChangeTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "remote"
    }
    
    required init(owner: GitRepository, remote: GitRemote, url: URL) {
        super.init(owner: owner, options: [])
        
        add(["set-url", (remote.name), url.absoluteString])
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as an operation was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.remoteUnableToChangeURL(message: output)
        }
    }
}
