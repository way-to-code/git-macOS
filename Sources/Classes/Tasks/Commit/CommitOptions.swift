//
//  GitCommitOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git clone operation
public class GitCommitOptions: ArgumentConvertible {

    public init(message: String) {
        self.message = message
    }
    
    public init(message: String, files: FileOptions) {
        self.message = message
        self.files = files
    }
    
    public enum FileOptions: ArgumentConvertible {
        
        /// Tells the command to commit only those files that were added to the index (staged for commit)
        case staged
        
        /// Tell the command to automatically stage files that have been modified and deleted, but new files you have not told Git about are not affected.
        case all
        
        func toArguments() -> [String] {
            switch self {
            case .all:
                return ["--all"]
            case .staged:
                return []
            }
        }
    }
    
    /// A message for commit must be provided
    public var message: String
    
    /// Options for manupilating files to commit
    public var files = FileOptions.all
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        // add file options
        arguments.append(contentsOf: files.toArguments())
        
        // add a commit message
        arguments.append(contentsOf: ["-m", message])
        
        return arguments
    }
}
