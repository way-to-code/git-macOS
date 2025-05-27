//
//  GitLogRecord.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// Describes a log record from a single commit
public class GitLogRecord: RepositoryLogRecord, Codable {
    
    /// Commit hash
    private(set) public var hash: String
    
    /// Abbreviated commit hash
    private(set) public var shortHash: String
    
    /// An author name
    private(set) public var authorName: String
    
    /// An email of an author
    private(set) public var authorEmail: String
    
    /// A commit subject
    private(set) public var subject: String
    
    /// Full parent hashes. If there are no parent commits, returns an empty string
    private(set) public var parentHashes: String
    
    /// A commit body
    private(set) public var body: String
    
    /// Committer date, strict ISO 8601 format
    private(set) public var commiterDate: Date
    
    /// Reference names
    private(set) public var refNames: String
}
