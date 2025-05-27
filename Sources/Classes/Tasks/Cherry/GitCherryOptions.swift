//
//  GitCherryOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git cherry operation
public class GitCherryOptions: ArgumentConvertible {
    
    // MARK: - Public
    public init(reference: GitLogOptions.Reference) {
        self.lhsReference = GitLogOptions.Reference(name: "HEAD")
        self.rhsReference = reference
    }
    
    /// The source reference to be used for comparison. Usually this should be HEAD
    public var lhsReference: GitLogOptions.Reference
    
    /// A reference to compare records with
    public var rhsReference: GitLogOptions.Reference
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var options: [String] = []
        
        // # Append contents of the source reference
        if lhsReference.name == "HEAD" {
            options.append(lhsReference.name)
        } else {
            options.append(contentsOf: lhsReference.toArguments())
        }
        
        // # Append contents of the comparing reference
        options.append(contentsOf: rhsReference.toArguments())
        
        return options
    }
}
