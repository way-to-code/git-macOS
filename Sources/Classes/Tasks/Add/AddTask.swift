//
//  AddTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class AddTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "add"
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus != 0 {
            throw GitRepository.FileError.unableToAddFiles(message: output ?? "Undefined error")
        }
    }
}
