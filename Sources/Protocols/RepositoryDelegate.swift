//
//  Repository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// Common delegate for handling repository events
public protocol RepositoryDelegate: AnyObject {
    /// Occurs when a clone operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressClone progress: String)
    
    /// Occurs when a commit operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressCommit progress: String)
    
    /// Occurs when a push operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressPush progress: String)
    
    /// Occurs when a pull operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressPull progress: String)
    
    /// Occurs when a fetch operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    func repository(_ repository: Repository, didProgressFetch progress: String)
    
    /// Occurs when a task is being started
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - arguments: The list of arguments for the starting command
    func repository(_ repository: Repository, willStartTaskWithArguments arguments: [String])
    
    /// Occurs when the merge operation finishes
    /// - Parameters:
    ///   - repository: A repository responsible for an event
    ///   - output: A raw output provided by the merge command
    func repository(_ repository: Repository, didFinishMerge output: String?)
}

public extension RepositoryDelegate {
    func repository(_ repository: Repository, didProgressCommit progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressClone progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressFetch progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressPush progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressPull progress: String) {
    }
    
    func repository(_ repository: Repository, willStartTaskWithArguments arguments: [String]) {
    }
    
    func repository(_ repository: Repository, didFinishMerge output: String?) {
    }
}
