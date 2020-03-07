//
//  GitStatusOptions.swift
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

/// A set of options used by the git status operation
public class GitStatusOptions: ArgumentConvertible {
    
    /// Returns a default options
    public static var `default` = GitStatusOptions()

    public init() {}

    /// The list of file names to be added
    internal var files: [String] = []
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments: [String] = []
        
        arguments.append("--porcelain")
        
        // Add file names
        for fileName in files {
            arguments.append(fileName)
        }
        
        return arguments
    }
}

// MARK: - Internal
internal extension GitStatusOptions {
    
    func addFiles(_ files: [String]) {
        self.files = files
    }
}
