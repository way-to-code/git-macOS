//
//  GitOutputParser.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class GitOutputParser {
    
    let output: String?
    
    // MARK: - Init
    init(output: String?) {
        self.output = output
    }
    
    func checkForConflict() -> Bool {
        guard let output = self.output else {
            return false
        }
        
        // This is not a good solution for checking a conflict like this. However, any other solution has not been found.
        let pattern = "(CONFLICT \\(.+\\):)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return true
        }
        
        let results = regex.matches(in: output, range: NSRange(output.startIndex..., in: output))
        return results.count > 0
    }
}
