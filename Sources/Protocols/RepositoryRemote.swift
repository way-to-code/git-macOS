//
//  RepositoryReference.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// Describes a remote in a repository
public protocol RepositoryRemote {

    /// A name of a remote in repository
    var name: String { get }
    
    /// URL to this remote
    var url: URL { get }
    
    /// Renames a remote to the new specified name. Changes are immediatelly applied to repository.
    ///
    /// - Parameter name: A new name to use for this remote.
    /// - Throws: An exception if a rename operation has been fallen
    mutating func rename(to name: String) throws
    
    /// Changes a remote URL for this remote. See git remote set-url command for details
    ///
    /// - Parameter url: A new URL of a remote
    mutating func changeURL(to newUrl: URL) throws
}
