//
//  RepositoryLogRecord.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// Describes a single log record in a repository
public protocol RepositoryLogRecord {
    
    /// Commit hash
    var hash: String { get }
    
    /// Abbreviated commit hash
    var shortHash: String { get }
    
    /// An author name
    var authorName: String { get }
    
    /// An email of an author
    var authorEmail: String { get }
    
    /// Full parent hashes. 
    ///
    /// If there are no parent commits, returns an empty string.
    /// Each parent is separated by a space
    var parentHashes: String { get }
    
    /// A commit subject
    var subject: String { get }
    
    /// A commit body
    var body: String { get }
    
    /// Committer date, strict ISO 8601 format
    var commiterDate: Date { get }
    
    /// Reference names
    var refNames: String { get }
}
