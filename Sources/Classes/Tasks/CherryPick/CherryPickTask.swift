//
//  CherryPickTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class CherryPickTask: RepositoryTask, TaskRequirable {

    // MARK: - TaskRequirable
    var name: String {
        return "cherry-pick"
    }

    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus != 0 {
            if checkCouldNotApplyError() {
                throw GitError.cherryPickCouldNotApplyChange(message: output ?? "")
            }
            
            throw GitError.cherryPickHasBeenFallen(message: output ?? "Unknown error")
        }
    }
    
    private func checkCouldNotApplyError() -> Bool {
        guard let output = self.output else {
            return false
        }
        
        // Git 2.21.*
        if output.starts(with: "error: could not apply") {
            return true
        }
        
        // Git 2.24.*
        return GitOutputParser(output: output).checkForConflict()
    }
}

