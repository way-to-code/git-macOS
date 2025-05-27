//
//  RepositoryReference.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A single reference in a repository
public protocol RepositoryReference {

    /// A unique id of a reference in SHA-1
    var id: String { get }
    
    /// Determines whether this reference is the current reference or not
    var active: Bool { get }
    
    /// A parent id of a reference if a reference has parent
    var parentId: String? { get }
    
    /// A reference relative path in a repository
    var path: String { get }
    
    /// A name of a reference
    var name: RepositoryReferenceName { get }
    
    /// A creator of this reference
    var author: String { get }
    
    /// Creation date of a reference
    var date: Date { get }
    
    /// The complete message in a commit and tag object
    var message: String? { get }
}
