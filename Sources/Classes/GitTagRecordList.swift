//
//  GitTagRecordList.swift
//  Git-macOS
//
//  Copyright (c) Jeremy Greenwood
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public final class GitTagRecordList {

    // MARK: - Public
    required public init(_ records: [RepositoryTagRecord] = []) {
        self.records = records
    }

    // MARK: - Private
    private(set) public var records: [RepositoryTagRecord]
}
