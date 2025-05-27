//
//  GitStashOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git stash operation
public class GitStashOptions: ArgumentConvertible {
    
    /// Returns the default options for the stash operation
    public static var `default`: GitStashOptions {
        return GitStashOptions()
    }
    
    // MARK: - Public
    
    /// Initializes options with the specified message. If a message is left nil, git assignes a message automatically
    public init(message: String? = nil) {
        self.message = message
    }
    
    /// If keepIndex option is used, all changes already added to the index are left intact.
    ///
    /// **Default** value for this property is **false**, meaning files added to index are also stashed by default.
    public var keepIndex: Bool = false
    
    /// If the option is used, all untracked files are also stashed and then cleaned up with git clean, leaving the working directory in a very clean state.
    /// This option is overrideb by stashAll option. Thus if stashAll is set to true, untracked files will be stashed depsite includeUntracked is set to false.
    ///
    /// **Default** value for this property is **true**, meaning untracked files are stashed by default.
    public var includeUntracked: Bool = true
    
    /// If the option is used, the ignored and untracked files are stashed and cleaned.
    /// You may use this option in case you want to leave the working directory in a very clean state.
    ///
    /// **Default** value for this property is **false**, meaning ignored files are not added to stash by default.
    public var stashAll: Bool = false
    
    /// A message to use for a stash record
    public var message: String? = nil
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments = ["push"]
        
        if keepIndex {
            arguments.append("--keep-index")
        }
        
        if includeUntracked && !stashAll {
            arguments.append("--include-untracked")
        }
        
        if stashAll {
            arguments.append("--all")
        }
        
        if let message = message {
            arguments.append("--message")
            arguments.append(message)
        }
        
        return arguments
    }
}
