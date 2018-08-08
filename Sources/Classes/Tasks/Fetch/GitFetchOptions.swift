//
//  GitFetchOptions.swift
//  Git-macOS
//
//  Copyright (c) 2018 Max A. Akhmatov
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
    
    /// By using this option you may specify that remotes you want to fetch, By default all remotes are fetched
    public var remotes = RemoteOptions.all
    
    /// Specify tags loading strategy for the fetch operation
    public var tags = TagOptions.all
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if progress {
            arguments.append("--progress")
        }
        
        // add remote options
        arguments.append(contentsOf: remotes.toArguments())
        
        // add tags options
        arguments.append(contentsOf: tags.toArguments())
        
        return arguments
    }
}
