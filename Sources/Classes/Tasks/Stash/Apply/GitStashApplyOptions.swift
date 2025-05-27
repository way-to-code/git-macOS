//
//  GitStashApplyOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root.

import Foundation

/// A set of options used by the git stash operation
public class GitStashApplyOptions: ArgumentConvertible {

    /// Returns the default options for the stash operation
    public static var `default`: GitStashApplyOptions {
        return GitStashApplyOptions()
    }
    
    // MARK: - Public
    private init() {
        stash = nil
    }
    
    /// Initializes a new instance of stash options with the specified stash record that should be applied.
    ///
    /// - Parameter stash: A stash record to be applied. In case of specifying nil, the first stash will be applied if present
    public init(stash: RepositoryStashRecord? = nil) {
        self.stash = stash
    }
    
    /// A stash record to be applied
    private(set) public var stash: RepositoryStashRecord?
    
    /// Specifies available options to do with a stash record after stash apply operation is finished
    public enum DropOptions {
        /// Stash record is not removed after the apply operation is done
        case keep
        
        /// Stash record will be removed **even** conflicts are detected after the apply operation is done.
        case drop
    }
    
    /// Specifies how the record should behave after the apply operation is done. See description of DropOptions for details
    public var dropStrategy: DropOptions = .keep
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments = ["apply"]
        
        if let stash = self.stash as? GitStashRecord {
            arguments.append("stash@{\(stash.stackIndex)}")
        }
        
        return arguments
    }
    
    func clone(options: GitStashApplyOptions, for stash: RepositoryStashRecord) -> GitStashApplyOptions {
        let instance = GitStashApplyOptions()
        instance.stash = stash
        instance.dropStrategy = options.dropStrategy
        
        return instance
    }
}
