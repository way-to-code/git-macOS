//
//  RepositoryTagRecord.swift
//  Git-macOS
//
//  Copyright (c) Jeremy Greenwood
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public protocol RepositoryTagRecord {
    var tag: String { get }
}
