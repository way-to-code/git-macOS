//
//  CheckoutOptions.swift
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

/// A set of options used by the git checkout operation
public class GitCheckoutOptions: ArgumentConvertible {

    // MARK: - Public
    public init() {
    }
    
    public init(files: [String]) {
        self.files = files
    }
    
    /// The list of file names to checkout.
    ///
    /// Is ignored when checkoutAllFiles is set
    public var files: [String] = []
    
    /// When set to true, checks out all files in the worktree.
    ///
    /// This is equivalent to git checkout . When set to true, files propery is ignored in that case
    public var checkoutAllFiles: Bool = true
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments: [String] = []
        
        if checkoutAllFiles {
            arguments.append(".")
        } else if files.count > 0 {
            // Do not interpret any more arguments as options.
            arguments.append("--")
            
            // Add file names
            for file in files {
                arguments.append(file)
            }
        }
        
        return arguments
    }
}
    
