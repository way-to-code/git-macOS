//
//  GitCleanOptions.swift
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

/// A set of options used by the git clean operation
public class GitCleanOptions {
    
    /// This is the same as the git `--force`
    public var force: Bool = false
    
    /// This is the same as the git `-d` option
    ///
    /// When specified, all untracked subdirectories will be removed
    public var includeUntrackedSubdirectories: Bool = false
}


// MARK: - ArgumentConvertible
extension GitCleanOptions: ArgumentConvertible {
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if force {
            arguments.append("-f")
        }
        
        if includeUntrackedSubdirectories {
            arguments.append("-d")
        }

        return arguments
    }
}
