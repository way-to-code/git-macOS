//
//  InitOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git init operation
public class GitInitOptions {
    
    /// The default set of options for the git init operation
    public static var `default`: GitInitOptions {
        return GitInitOptions()
    }
    
    public init() {
    }
    
    /// Specifies the initial branch name for a new repository.
    /// If not specified, the default name will be determined by git
    public var initialBranchName: String?
    
    /// If set to true, creates a bare repository. The default value is false
    public var bare: Bool = false
}

// MARK: - ArgumentConvertible
extension GitInitOptions: ArgumentConvertible {
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if let branchName = initialBranchName, branchName.count > 0 {
            arguments.append("--initial-branch=\(branchName)")
        }
        
        if bare {
            arguments.append("--bare")
        }
        
        return arguments
    }
}
