//
//  GitCloneOptions.swift
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
public class GitCloneOptions {
    
    /// Returns the default options for the clone operation
    public static var `default`: GitCloneOptions {
        return GitCloneOptions()
    }
    
    public init() {}
    
    public enum CheckoutOptions {
        /// Checkout of HEAD is performed after the clone is complete. This is default option
        case checkout
        
        /// No checkout of HEAD is performed after the clone is complete.
        case noCheckout
        
        func toArguments() -> [String] {
            switch self {
            case .checkout:
                return []
            case .noCheckout:
                return ["--no-checkout"]
            }
        }
    }
    
    public enum DepthOptions {
        /// A HEAD revision is downloaded only. This may be helpfull when you want to reduce a repository downloading time
        case head

        /// Limit commit history by the specified number of revisions. This will help to reduce a downloading time of a repository.
        /// If a number of revisions is zero, unlimited strategy will be used
        case limited(numberOfRevisions: UInt)
        
        /// All commit history is downloaded.
        case unlimited
        
        func toArguments() -> [String] {
            if case .limited(numberOfRevisions: 0) = self {
                // fallback to the unlimited number of revisions, as zero is specified
                return value(for: .unlimited)
            }
            
            return value(for: self)
        }
        
        private func value(for strategy: DepthOptions) -> [String] {
            switch strategy {
            case .head:
                return ["--depth", "1"]
            case .limited(let numberOfRevisions):
                return ["--depth", "\(numberOfRevisions)"]
            case .unlimited:
                return []
            }
        }
    }

    public enum BranchOptions {
        /// All branches will be cloned
        case all
        
        /// Repository's head branch is cloned. Usually, this is the same as master
        case head
        
        /// The master branch is only cloned
        case master
        
        /// Clone only the history leading to the tip of a single branch.
        /// You can also specify a name of a branch you want to clone.
        case single(named: String)

        func toArguments() -> [String] {
            switch self {
            case .all:
                return ["--no-single-branch"]
                
            case .head:
                return ["--single-branch"]
                
            case .master:
                return ["--single-branch", "--branch", "master"]
                
            case .single(let referenceName):
                return ["--single-branch", "--branch", referenceName]
            }
        }
    }
    
    public enum TagsOptions {
        /// Tags are fetched during a clone operation
        case fetch
        
        /// Don’t clone any tags. This is useful e.g. to maintain minimal clones of the default branch of some repository for search indexing.
        case noTags
        
        func toArguments() -> [String] {
            switch self {
            case .fetch:
                return []
                
            case .noTags:
                return ["--no-tags"]
            }
        }
    }
    
    /// Operate quietly. Progress is not reported to the standard error stream.
    var quiet = true
    
    /// Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified.
    /// This flag forces progress status even if the standard error stream is not directed to a terminal.
    var progress = true
    
    /// By using this option you may specify that branches you want to clone, By default all branches are cloned
    public var branches = BranchOptions.all
    
    /// A shallow clone options specifying how a clone options must behave with downloading commit history.
    /// By default all commit history is downloaded
    public var depth = DepthOptions.unlimited
    
    /// Checkout strategy that should be applied just after the clone operation is finished.
    /// If you do not specified this option, checkout of HEAD is performed
    public var checkout = CheckoutOptions.checkout
    
    /// Indicates whether to fetch tags with a clone operation or not
    public var tags = TagsOptions.fetch
    
    func toArguments() -> [String] {
        var arguments = [String]()
        
        if quiet {
            arguments.append("--quiet")
        }
        
        if progress {
            arguments.append("--progress")
        }
        
        // add depth options
        arguments.append(contentsOf: depth.toArguments())
        
        // add checkout options
        arguments.append(contentsOf: checkout.toArguments())
        
        // add branch options
        arguments.append(contentsOf: branches.toArguments())
        
        // add tags options
        arguments.append(contentsOf: tags.toArguments())
        
        return arguments
    }
}


