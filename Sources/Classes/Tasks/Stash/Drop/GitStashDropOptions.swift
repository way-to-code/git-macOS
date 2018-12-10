//
//  GitStashListOptions.swift
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

import Cocoa

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
