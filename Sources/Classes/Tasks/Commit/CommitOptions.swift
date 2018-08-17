//
//  GitCommitOptions.swift
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

/// A set of options used by the git clone operation
public class GitCommitOptions: ArgumentConvertible {

    public init(message: String) {
        self.message = message
    }
    
    public enum FileOptions: ArgumentConvertible {
        /// Tell the command to automatically stage files that have been modified and deleted, but new files you have not told Git about are not affected.
        case all
        
        func toArguments() -> [String] {
            switch self {
            case .all:
                return ["--all"]
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
