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
    
    /// A number of commits to load. Default value is not specified that means there is not limit.
    public var limit: UInt?
    
    /// Limit the commits output to ones with author/committer header lines that match the specified pattern (regular expression).
    public var author: String?

    /// Show commits more recent than a specific date.
    public var after: Date?
    
    /// Show commits older than a specific date.
    public var before: Date?
    
    internal struct ReferenceComparator: ArgumentConvertible {
        enum Strategy {
            case compareRemoteWithLocal
            case compareLocalWithRemote
        }
        
        var strategy = Strategy.compareRemoteWithLocal
        
        var remoteReference: String
        var localReference: String
        
        func toArguments() -> [String] {
            switch strategy {
                case .compareRemoteWithLocal: return ["\(remoteReference)..\(localReference)"]
                case .compareLocalWithRemote: return ["\(localReference)..\(remoteReference)"]
            }
            
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
        
        if let comparator = compareReference {
            arguments.append(contentsOf: comparator.toArguments())
        }
        
        return arguments
    }
}

