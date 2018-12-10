//
//  GitPushOptions.swift
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

/// A set of options used by the git `pull` command
public class GitPullOptions: ArgumentConvertible {

    /// Returns the default options for the pull operation
    public static var `default`: GitPullOptions {
        return GitPullOptions()
    }
    
    public init() {
    }
    
    ///  When autoCommit is false, the pull operation performs the merge but pretend the merge failed and do not autocommit, to give the user a chance to inspect and further tweak the merge result before committing. Default value is false
    public var autoCommit: Bool = false
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if autoCommit {
            arguments.append("--commit")
        } else {
            arguments.append("--no-commit")
        }
        
        return arguments
    }
}
