//
//  GitLogRecord.swift
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
