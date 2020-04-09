//
//  GitCherryPickOptions.swift
//  Git-macOS
//
//  Copyright (c) 2020 Max A. Akhmatov
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

/// A set of options used by the git cherry pick operation
public class GitCherryPickOptions: ArgumentConvertible {
    
    // MARK: - Public
    public init(changeset: String) {
        self.changeset = changeset
    }
    
    /// Indicates whether to commit the result immediatlly or not
    public var shouldCommit: Bool = false
    
    /// A commit hash or identifier to use for the operation
    public var changeset: String
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var options: [String] = []
        
        if !shouldCommit {
            options.append("-n")
        }
        
        options.append(changeset)
        
        return options
    }
}
