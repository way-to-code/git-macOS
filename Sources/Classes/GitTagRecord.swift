//
//  GitTagRecord.swift
//  Git-macOS
//
//  Copyright (c) Jeremy Greenwood
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public final class GitTagRecord: RepositoryTagRecord {
    internal init(tag: String) {
        self.tag = tag
    }

    public var tag: String
}
