//
//  GitAddOptions.swift
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

/// A set of options used by the git add operation
public class GitAddOptions: ArgumentConvertible {
    
    /// Returns a default options
    public static var `default` = GitAddOptions()

    public init() {}

    /// Allows adding otherwise ignored files.
    ///
    /// Default value for this property is **false**
    public var force: Bool = false
    
    /// If some files could not be added because of errors indexing them, do not abort the operation, but continue adding the others
    ///
    /// Default value for this property is **false**
    public var ignoreErrors: Bool = false
    
    /// Update the index just where it already has an entry matching pathspec. This removes as well as modifies index entries to match the working tree, but adds no new files.
    ///
    /// Default value for this property is **false**
    public var update: Bool = false
    
    /// The list of file names to be added
    internal var files: [String] = []
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments: [String] = []
        
        if force {
            arguments.append("--force")
        }
        
        if ignoreErrors {
            arguments.append("--ignore-errors")
        }
        
        if update {
            arguments.append("--update")
        }
        
        // Add file names
        for fileName in files {
            arguments.append(fileName)
        }
        
        return arguments
    }
}

// MARK: - Internal
internal extension GitAddOptions {
    
    func addFiles(_ files: [String]) {
        self.files = files
    }
}
