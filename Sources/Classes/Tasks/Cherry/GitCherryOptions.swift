//
//  GitCherryOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
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

/// A set of options used by the git cherry operation
public class GitCherryOptions: ArgumentConvertible {
    
    // MARK: - Public
    public init(reference: GitLogOptions.Reference) {
        self.lhsReference = GitLogOptions.Reference(name: "HEAD")
        self.rhsReference = reference
    }
    
    /// The source reference to be used for comparison. Usually this should be HEAD
    public var lhsReference: GitLogOptions.Reference
    
    /// A reference to compare records with
    public var rhsReference: GitLogOptions.Reference
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var options: [String] = []
        
        // # Append contents of the source reference
        if lhsReference.name == "HEAD" {
            options.append(lhsReference.name)
        } else {
            options.append(contentsOf: lhsReference.toArguments())
        }
        
        // # Append contents of the comparing reference
        options.append(contentsOf: rhsReference.toArguments())
        
        return options
    }
}
