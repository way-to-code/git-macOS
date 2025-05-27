//
//  GitLogRecord.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// Describes a single stash record
public class GitStashRecord: GitLogRecord, RepositoryStashRecord {

    internal(set) public var stackIndex: Int = 0
}
