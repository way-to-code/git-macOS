//
//  InitOptions.swift
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

/// A set of options used by the git init operation
public class GitInitOptions {
    
    /// The default set of options for the git init operation
    public static var `default`: GitInitOptions {
        return GitInitOptions()
    }
    
    public init() {
    }
    
    /// Specifies the initial branch name for a new repository.
    /// If not specified, the default name will be determined by git
    public var initialBranchName: String?
    
    /// If set to true, creates a bare repository. The default value is false
    public var bare: Bool = false
}

// MARK: - ArgumentConvertible
extension GitInitOptions: ArgumentConvertible {
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if let branchName = initialBranchName, branchName.count > 0 {
            arguments.append("--initial-branch=\(branchName)")
        }
        
        if bare {
            arguments.append("--bare")
        }
        
        return arguments
    }
}
