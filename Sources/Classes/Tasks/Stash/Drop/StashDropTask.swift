//
//  GitStashListOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class StashDropTask: RepositoryTask, TaskRequirable {
    var name: String {
        return "stash"
    }
    
    private(set) var records = GitStashRecordList([])
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            throw GitError.stashDropError(message: self.output ?? "uknown error")
        }
    }
}
