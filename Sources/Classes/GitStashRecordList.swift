//
//  GitStashRecordList.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// List containing stash records
public class GitStashRecordList {
    
    // MARK: - Public
    required public init(_ records: [RepositoryStashRecord] = []) {
        self.records = records
    }
    
    // MARK: - Private
    private(set) public var records: [RepositoryStashRecord]
}
