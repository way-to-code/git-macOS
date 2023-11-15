//
//  GitLogOptions.swift
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

/// A set of options used by the git log operation
public class GitLogOptions: ArgumentConvertible {
    /// Returns the default options for the log operation
    public static var `default`: GitLogOptions {
        return GitLogOptions()
    }
    
    public init() {
    }
    
    /// A number of commits to load. Default value is not specified that means there is not limit.
    public var limit: UInt?
    
    /// Limit the commits output to ones with author/committer header lines that match the specified pattern (regular expression).
    public var author: String?

    /// Show commits more recent than a specific date.
    public var after: Date?
    
    /// Show commits older than a specific date.
    public var before: Date?
    
    /// A reference (branch) to list log records for.
    ///
    /// When specified it is equivalent to the following command: git log `<remote_name>/<reference_name>`
    public var reference: Reference?
    
    /// Do not fetch commits with more than one parent
    public var noMerges: Bool = false
    
    internal struct ReferenceComparator: ArgumentConvertible {
        var lhsReferenceName: String
        var rhsReferenceName: String
        
        func toArguments() -> [String] {
            return ["\(lhsReferenceName)..\(rhsReferenceName)"]
        }
    }
    
    internal var compareReference: ReferenceComparator?
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if let limit = limit {
            arguments.append("-\(limit)")
        }
        
        if let after = after {
            arguments.append("--after=\"\(Formatter.iso8601.string(from: after))\"")
        }
        
        if let before = before {
            arguments.append("--before=\"\(Formatter.iso8601.string(from: before))\"")
        }
        
        if let author = author {
            arguments.append("--author=\"\(author)\"")
        }
        
        if noMerges {
            arguments.append("--no-merges")
        }
        
        if let reference = reference {
            arguments.append(contentsOf: reference.toArguments())
        } else if let comparator = compareReference {
            arguments.append(contentsOf: comparator.toArguments())
        }
        
        return arguments
    }
}

// MARK: - Reference
public extension GitLogOptions {
    struct Reference: ArgumentConvertible {
        // MARK: - Init
        public init(name: String) {
            self.name = name
            self.remote = nil
        }
        
        public init(name: String, remote: RepositoryRemote) {
            self.name = name
            self.remote = remote
        }
        
        /// A name of a reference
        public var name: String
        
        /// A name of a remote. If a remote is not provided
        public var remote: RepositoryRemote?
        
        /// The first remote when a remote is not provided.
        internal var firstRemote: RepositoryRemote?
        
        func toArguments() -> [String] {
            if let remote = firstRemote {
                return ["\(remote.name)/\(name)"]
            } else if let remote = remote {
                return ["\(remote.name)/\(name)"]
            } else {
                return []
            }
        }
    }
}
