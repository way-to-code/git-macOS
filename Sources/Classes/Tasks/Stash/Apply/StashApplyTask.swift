//
//  StashApplyTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class StashApplyTask: RepositoryTask, TaskRequirable {
    var name: String {
        return "stash"
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            if checkForConflict() {
                // a conflict has been detected
                throw GitError.stashApplyConflict(message: self.output ?? "")
            }
            
            throw GitError.stashApplyError(message: self.output ?? "uknown error")
        }
    }
    
    private func checkForConflict() -> Bool {
        return GitOutputParser(output: output).checkForConflict()
    }
}
