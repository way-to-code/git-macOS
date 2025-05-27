//
//  ResetTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class ResetTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "reset"
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus != 0 {
            throw GitRepository.FileError.unableToReset(message: output ?? "Undefined error")
        }

    }
}
