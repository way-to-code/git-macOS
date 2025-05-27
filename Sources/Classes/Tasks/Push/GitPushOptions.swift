//
//  GitPushOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git push operation
public class GitPushOptions: ArgumentConvertible {
    
    /// Returns the default options for the push operation
    public static var `default`: GitPushOptions {
        return GitPushOptions()
    }
    
    public init() {
    }
    
    public enum BranchOptions: ArgumentConvertible {
        /// Push all branches (i.e. refs under refs/heads/); cannot be used with other refspec.
        ///
        /// This equals to a raw git command:
        /// ````
        /// git push --all
        /// ````
        case all
        
        /// Push a single branch that matches the specified name in a remote.
        ///
        /// This equals to a raw git command:
        /// ````
        /// git push origin master
        /// ````
        /// Where *origin* is a **remote**, and *master* is a **name** of a branch
        case single(name: String, remote: RepositoryRemote)

        /// All refs under refs/tags are pushed, in addition to refspecs explicitly listed on the command line.
        ///
        /// This equals to a raw git command:
        /// ```
        /// git push --tags
        /// ```
        case tags
        
        func toArguments() -> [String] {
            switch self {
            case .all:
                return ["--all"]
            case .single(let name, let remote):
                return [remote.name, name]
            case .tags:
                return ["--tags"]
            }
        }
    }
    
    /// By using this option you may specify those branches you want to push. By default all branches are pushed
    public var branches = BranchOptions.all
    
    /// When set to true every branch that is up to date or successfully pushed will be upstream (tracking) reference.
    /// The default value for this option is false
    public var upstream: Bool = false
    
    /// A list of custom string parameters to be passed for the git push operation.
    ///
    /// This is equivalent to `--push-option` in git
    /// All empty strings in the list are ignored. Each parameter must have at least one character.
    public var parameters: [String] = []
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        // add branch options
        arguments.append(contentsOf: branches.toArguments())
        
        // Add custom parameters if any
        for option in parameters where option.count > 0 {
            arguments.append("--push-option=\(option)")
        }
        
        if upstream {
            arguments.append("--set-upstream")
        }
        
        return arguments
    }
}
