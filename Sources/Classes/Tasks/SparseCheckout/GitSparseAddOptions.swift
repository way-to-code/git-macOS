//
//  GitSparseAddOptions.swift
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

public struct GitSparseAddOptions: ArgumentConvertible {
    /// Relative folder paths to be added to the sparse checkout.
    /// E.q. some/folder
    public var filePaths: [String]
    
    public init(filePaths: [String]) {
        self.filePaths = filePaths
    }
    
    func toArguments() -> [String] {
        guard !filePaths.isEmpty else { return [] }
        
        var arguments = ["add"]
        
        for path in filePaths {
            arguments.append(path.replacingOccurrences(
                of: " ",
                with: "\\ "))
        }
        
        return arguments
    }
}
