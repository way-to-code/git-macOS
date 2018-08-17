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

/// A set of options used by the git clone operation
public class GitPushOptions: ArgumentConvertible {
    
    /// Returns the default options for the push operation
    public static var `default`: GitPushOptions {
        return GitPushOptions()
    }
    
    public enum BranchOptions: ArgumentConvertible {
        /// Push all branches (i.e. refs under refs/heads/); cannot be used with other <refspec>.
        case all
        
        func toArguments() -> [String] {
            switch self {
            case .all:
                return ["--all"]
            }
        }
    }
    
    /// By using this option you may specify that branches you want to push, By default all branches are pushed
    public var branches = BranchOptions.all
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        // add branch options
        arguments.append(contentsOf: branches.toArguments())
        
        return arguments
    }
}
