//
//  GitTagListOptions.swift
//  Git-macOS
//
//  Created by Max Akhmatov on 06/03/22.
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

/// A set of options that are used for the listing tags operation
public struct GitTagListOptions: ArgumentConvertible {
    public static var `default` = GitTagListOptions()
    
    /// Creates options with the pattern match
    public static func pattern(_ pattern: String) -> GitTagListOptions {
        .init(pattern: pattern)
    }
    
    // MARK: - Init
    public init(pattern: String? = nil) {
        self.pattern = pattern
    }
    
    /// List tags with optional pattern matching `(e.g. git tag --list 'v-*')`
    public let pattern: String?
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        arguments.append("-l")
        
        if let pattern = pattern {
            arguments.append("\(pattern)")
        }
        
        return arguments
    }
}
