//
//  GitStashOptions.swift
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
