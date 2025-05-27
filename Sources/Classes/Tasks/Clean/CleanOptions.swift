//
//  GitCleanOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git clean operation
public class GitCleanOptions {
    
    /// This is the same as the git `--force`
    public var force: Bool = false
    
    /// This is the same as the git `-d` option
    ///
    /// When specified, all untracked subdirectories will be removed
    public var includeUntrackedSubdirectories: Bool = false
}


// MARK: - ArgumentConvertible
extension GitCleanOptions: ArgumentConvertible {
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if force {
            arguments.append("-f")
        }
        
        if includeUntrackedSubdirectories {
            arguments.append("-d")
        }

        return arguments
    }
}
