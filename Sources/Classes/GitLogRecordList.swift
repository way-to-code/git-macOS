//
//  GitLogRecordList.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// List containing log records
public class GitLogRecordList {
    
    // MARK: - Public
    required public init(_ records: [RepositoryLogRecord] = []) {
        self.records = records
    }
    
    // MARK: - Private
    private(set) public var records: [RepositoryLogRecord]
}
