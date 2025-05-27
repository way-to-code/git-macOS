//
//  GitPushOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

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
