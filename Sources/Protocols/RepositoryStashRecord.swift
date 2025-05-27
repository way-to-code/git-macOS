//
//  RepositoryStashRecord.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// Describes a single shash record in a repository
public protocol RepositoryStashRecord: RepositoryLogRecord {
    
    /// An index of this stash record in repository.
    ///
    /// In general, you **must not** count on a value of the property as it may become invalid, for example when stash records are changed outside.
    /// Only the **hash** field can be used to unique identify a stash record.
    var stackIndex: Int { get }
}
