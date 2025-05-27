//
//  GitTagListOptions.swift
//  Git-macOS
//
//  Copyright (c) Max Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options that are used for the listing tags operation
public struct GitTagListOptions: ArgumentConvertible {
    public static var `default` = GitTagListOptions()
    
    /// Creates options with the pattern match
    public static func pattern(_ pattern: String) -> GitTagListOptions {
        .init(pattern: pattern)
    }
    
    // MARK: - Init
    public init(pattern: String? = nil) {
        self.pattern = pattern
    }
    
    /// List tags with optional pattern matching `(e.g. git tag --list 'v-*')`
    public let pattern: String?
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        arguments.append("-l")
        
        if let pattern = pattern {
            arguments.append("\(pattern)")
        }
        
        return arguments
    }
}
