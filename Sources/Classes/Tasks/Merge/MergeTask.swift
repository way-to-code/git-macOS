//
//  MergeTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class MergeTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "merge"
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if parameters.contains("--abort"), terminationStatus != 0 {
            throw GitError.mergeUnableToAbort(message: output ?? "Unknown error")
        }
        
        if terminationStatus != 0 {
            if checkForConflict() {
                throw RepositoryError.mergeFinishedWithConflicts
            } else {
                throw GitError.mergeHasBeenFallen(message: output ?? "Unknown error")
            }
        }
        
        repository.delegate?.repository(repository, didFinishMerge: output)
    }
    
    private func checkForConflict() -> Bool {
        return GitOutputParser(output: output).checkForConflict()
    }
}
