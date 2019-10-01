//
//  GitStashApplyOptions.swift
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
