//
//  CherryTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class CherryTask: RepositoryTask, TaskRequirable {
    
    private(set) var result: GitCherryResult = .init(revisions: [])

    // MARK: - TaskRequirable
    var name: String {
        return "cherry"
    }

    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus != 0 {
            throw GitError.cherryHasBeenFallen(message: output ?? "Unknown error")
        }
        
        var revisions: [GitCherryRevision] = []
        
        if let output = self.output {
            for line in output.split(separator: "\n") {
                guard line.count > 2 else { continue }
                
                let sign = String(line.prefix(1))
                let hash = String(line.suffix(from: line.index(line.startIndex, offsetBy: 2))).trimmingCharacters(in: .whitespacesAndNewlines)
                
                revisions.append(.init(hash: hash, type: .init(sign: sign)))
            }
        }
        
        result = GitCherryResult(revisions: revisions)
    }
}

