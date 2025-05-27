//
//  GitMergeStatus.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

/// Current merge statis of a repository
public class GitMergeStatus {
    
    internal init() {    
    }
    
    /// Determines whether an active merge is in progress in a repository
    public internal(set) var isMergeInProgress: Bool = false
    
    /// Determines whether an active squash is in progress in a repository
    public internal(set) var isSquashInProgress: Bool = false
}
