//
//  BranchOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git branch operation
public class GitBranchOptions: ArgumentConvertible {
    
    /// Returns the default options for the branch operation
    public static var `default`: GitBranchOptions {
        return GitBranchOptions()
    }
    
    public init() {
    }
    
    /// Specifies the starting point of a new branch - a reference to be used to create a branch from.
    /// If this value is not specified, a new branch is created from the current active reference.
    public var fromReferenceName: String?
    
    /// Turn on/off branch colors, even when the configuration file gives provides own color output.
    var useColor: Bool = false

    func toArguments() -> [String] {
        var arguments = [String]()
        
        if let referenceName = fromReferenceName, referenceName.count > 0 {
            arguments.append(referenceName)
        }
        
        if useColor {
            arguments.append("--color")
        } else {
            arguments.append("--no-color")
        }
        
        return arguments
    }
}
