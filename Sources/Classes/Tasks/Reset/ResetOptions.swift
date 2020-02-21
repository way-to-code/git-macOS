//
//  GitResetOptions.swift
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

/// A set of options used by the git reset operation
public class GitResetOptions: ArgumentConvertible {
    
    public init() {
    }
    
    /// A mode to be used by git reset operation. If the mode is not specified, the operation will use the default option defined by git
    public var mode: Mode?
    
    /// A commit to be used for the reset operation. If the commit is not specified, the operation will use the default option defined by git
    public var commit: String?
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments: [String] = []
        
        if let mode = mode {
            switch mode {
            case .soft: arguments.append("--soft")
            case .mixed: arguments.append("--mixed")
            case .hard: arguments.append("--hard")
            case .merge: arguments.append("--merge")
            case .keep: arguments.append("--keep")
            }
        }
        
        if let commit = commit {
            arguments.append(commit)
        }
        
        return arguments
    }
}

public extension GitResetOptions {
    
    enum Mode {
        
        /// Does not touch the index file or the working tree at all
        case soft
        
        /// Resets the index but not the working tree
        case mixed
        
        /// Resets the index and working tree
        case hard
        
        /// Resets the index and updates the files in the working tree that are different between commit and HEAD,
        case merge
        
        /// Resets index entries and updates files in the working tree that are different between commit and HEAD
        case keep
    }
}
