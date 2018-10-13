//
//  RepositoryLogRecord.swift
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
    
    /// A commit subject
    var subject: String { get }
    
    /// A commit body
    var body: String { get }
    
    /// Committer date, strict ISO 8601 format
    var commiterDate: Date { get }
    
    /// Reference names
    var refNames: String { get }
}
