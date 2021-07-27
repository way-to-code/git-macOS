//
//  BranchOptions.swift
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

/// A set of options used by the git branch operation
public class GitBranchOptions: ArgumentConvertible {
    
    /// Returns the default options for the branch operation
    public static var `default`: GitBranchOptions {
        return GitBranchOptions()
    }
    
    public init() {
    }
    
    /// Specifies the starting point of a new branch - a reference to be used to create a branch from.
    /// If this value is not specified, a new branch is created from the current active reference.
    public var fromReferenceName: String?
    
    /// Turn on/off branch colors, even when the configuration file gives provides own color output.
    var useColor: Bool = false

    func toArguments() -> [String] {
        var arguments = [String]()
        
        if let referenceName = fromReferenceName, referenceName.count > 0 {
            arguments.append(referenceName)
        }
        
        if useColor {
            arguments.append("--color")
        } else {
            arguments.append("--no-color")
        }
        
        return arguments
    }
}
