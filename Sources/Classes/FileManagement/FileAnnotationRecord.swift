//
//  FileAnnotationRecords.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A basic file annotation information
open class FileAnnotationRecord {
    
    /// An author of a change
    public var author: String!
    
    /// A line number
    public var line: UInt!
    
    /// A unique id of a file change
    public var id: String!
}
