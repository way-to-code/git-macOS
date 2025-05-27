//
//  GitCloneOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git clone operation
public class GitCloneOptions {
    /// Returns the default options for the clone operation
    public static var `default`: GitCloneOptions {
        return GitCloneOptions()
    }
    
    public init() {}
    
    /// Operate quietly. Progress is not reported to the standard error stream.
    public var quiet = true
    
    /// Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified.
    /// This flag forces progress status even if the standard error stream is not directed to a terminal.
    public var progress = true
    
    /// By using this option you may specify that branches you want to clone, By default all branches are cloned
    public var branches = BranchOptions.all
    
    /// A shallow clone options specifying how a clone options must behave with downloading commit history.
    /// By default all commit history is downloaded
    public var depth = DepthOptions.unlimited
    
    /// Checkout strategy that should be applied just after the clone operation is finished.
    /// If you do not specified this option, checkout of HEAD is performed
    public var checkout = CheckoutOptions.checkout
    
    /// Sparse checkout strategy. This option can be used to limit the grow of working copy if needed
    public var sparse = SparseOptions.noSparse
    
    /// Indicates whether to fetch tags with a clone operation or not
    public var tags = TagsOptions.fetch
    
    /// Sets the filtering options for the clone operation
    public var filter = FilterOptions.noFilter
    
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
        
        // add sparse checkout
        arguments.append(contentsOf: sparse.toArguments())
        
        // add filter options
        arguments.append(contentsOf: filter.toArguments())
        
        return arguments
    }
}

// MARK: - CheckoutOptions
public extension GitCloneOptions {
    enum CheckoutOptions {
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
}

// MARK: - DepthOptions
public extension GitCloneOptions {
    enum DepthOptions {
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
}

// MARK: - BranchOptions
public extension GitCloneOptions {
    enum BranchOptions {
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
}

// MARK: - TagsOptions
public extension GitCloneOptions {
    enum TagsOptions {
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
}

// MARK: - SparseOptions
public extension GitCloneOptions {
    enum SparseOptions {
        /// A sparse checkout with only files in the top level directory initially being present.
        case sparse
        
        /// No sparse checkout will be available for the working copy
        case noSparse
        
        func toArguments() -> [String] {
            switch self {
            case .sparse:
                return ["--sparse"]
                
            case .noSparse:
                return []
            }
        }
    }
}

// MARK: - FilterOptions
public extension GitCloneOptions {
    enum FilterOptions {
        /// No filtering options
        case noFilter
        
        /// Omits all blobs
        case omitAllBlobs
        
        /// Omits all blobs larger than the given size in bytes
        case omitBlobsLargerThanSize(Int)
        
        /// Custom filter spec (e.q. --filter=\<custom-filter-spec\>).
        /// Special characters ~!@#$^&*()[]{}\\;\",<>?'\` are escaped (plus spaces and newlines)
        case custom(String)
        
        func toArguments() -> [String] {
            switch self {
            case .noFilter:
                return []
            case .omitAllBlobs:
                return ["--filter=blob:none"]
            case let .omitBlobsLargerThanSize(size):
                return ["--filter=blob:limit=\(size)"]
            case let .custom(filterSpec):
                let escapingCharacters = CharacterSet(
                    charactersIn: "~!@#$^&*()[]{}\\;\",<>?'` \n").inverted
                
                let escapedSpec = filterSpec.addingPercentEncoding(
                    withAllowedCharacters: escapingCharacters) ?? filterSpec
                
                return ["--filter=\(escapedSpec)"]
            }
        }
    }
}
