//
//  GitCherryPickOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git cherry pick operation
public class GitCherryPickOptions: ArgumentConvertible {
    
    // MARK: - Public
    public init(changeset: String) {
        self.changeset = changeset
    }
    
    /// Indicates whether to commit the result immediatlly or not
    public var shouldCommit: Bool = false
    
    /// A commit hash or identifier to use for the operation
    public var changeset: String
    
    /// A parent number (starting from 1) of the merge commit. Specify if you want to cherry pick the merges.
    public var mainline: Int?
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var options: [String] = []
        
        if !shouldCommit {
            options.append("-n")
        }
        
        if let mainline {
            options.append("-m")
            options.append("\(mainline)")
        }
        
        options.append(changeset)
        
        return options
    }
}
