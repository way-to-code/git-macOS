//
//  GitFetchOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git fetch operation
public class GitFetchOptions: ArgumentConvertible {
    
    /// Returns the default options for the fetch operation
    public static var `default`: GitFetchOptions {
        return GitFetchOptions()
    }
    
    public init() {}
    
    /// Indicate that remotes need to be fetched from remote repository
    public enum RemoteOptions: ArgumentConvertible {
        /// Fetch all remotes
        case all
        
        func toArguments() -> [String] {
            switch self {
            case .all: return ["--all"]
            }
        }
    }
    
    public enum TagOptions: ArgumentConvertible {
        /// Fetch all tags from the remote (i.e., fetch remote tags refs/tags/* into local tags with the same name),
        /// in addition to whatever else would otherwise be fetched.
        case all
        
        /// By default, tags that point at objects that are downloaded from the remote repository are fetched and stored locally.
        /// This option disables this automatic tag following
        case none
        
        func toArguments() -> [String] {
            switch self {
            case .all: return ["--tags"]
            case .none: return ["--no-tags"]
            }
        }
    }
    
    /// Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified.
    /// This flag forces progress status even if the standard error stream is not directed to a terminal.
    var progress = true
    
    /// Indicates whether to use --force option for the git or not
    public var force = false
    
    /// By using this option you may specify that remotes you want to fetch, By default all remotes are fetched
    public var remotes = RemoteOptions.all
    
    /// Specify tags loading strategy for the fetch operation
    public var tags = TagOptions.all
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if progress {
            arguments.append("--progress")
        }
        
        if force {
            arguments.append("--force")
        }
        
        // add remote options
        arguments.append(contentsOf: remotes.toArguments())
        
        // add tags options
        arguments.append(contentsOf: tags.toArguments())
        
        return arguments
    }
}
