//
//  StatusTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class StatusTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "status"
    }
    
    // MARK: - Output
    private(set) var status = GitFileStatusList()
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        status = GitFileStatusList()
        
        if let output = self.output {
            for line in output.split(separator: "\n") {
                guard line.count > 3 else { continue }
                
                let fileState = String(line.prefix(2))
                var fileName = String(line.suffix(from: line.index(line.startIndex, offsetBy: 3)))
                
                // When file name contains spaces, need to ensure leading and trailing quoes escapes are removed
                fileName = fileName.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))
                
                try? status.add(.init(path: fileName, state: fileState))
            }
        }
    }
}
