//
//  GitStashListOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class GitStashDropOptions: ArgumentConvertible {
    
    /// Returns the default options for the stash drop operation
    public static var `default`: GitStashDropOptions {
        return GitStashDropOptions()
    }
    
    // MARK: - Public
    private init() {
        stash = nil
    }
    
    /// Initializes a new instance of stash options with the specified stash record that should be dropped.
    ///
    /// - Parameter stash: A stash record to be dropped. In case of specifying nil, the first stash will be dropped if present
    public init(stash: RepositoryStashRecord? = nil) {
        self.stash = stash
    }
    
    /// A stash record to be applied
    private(set) public var stash: RepositoryStashRecord?
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments = ["drop"]
        
        if let stash = self.stash as? GitStashRecord {
            arguments.append("stash@{\(stash.stackIndex)}")
        }
        
        return arguments
    }
}
