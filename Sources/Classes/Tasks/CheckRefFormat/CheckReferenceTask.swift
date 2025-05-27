//
//  CheckRefFormatTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class CheckRefFormatTask: RepositoryTask, TaskRequirable {
    
    // MARK: - Output
    var message: String {
        return output ?? ""
    }
    
    // MARK: - TaskRequirable
    var name: String {
        return "check-ref-format"
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
    }
}
