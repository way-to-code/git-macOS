//
//  RepositoryReference.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public protocol RepositoryReferenceName {

    /// The full name of a reference
    ///
    /// Returns a reference name by removing `"refs"`from the path.
    ///
    /// Some examples are below:
    ///
    /// - `refs/stash` → `stash`
    /// - `refs/heads/master` → `heads/master`
    /// - `refs/remotes/origin/HEAD` → `remotes/origin/HEAD`
    /// - `refs/remotes/origin/feature/git` → `remotes/origin/feature/git`
    var fullName: String { get }

    /// A short reference name
    ///
    /// Returns a reference name by removing `"refs"` and the second component from the path (for instance, `"refs/heads"` or `"refs/pull"`). If the path contains only two components, returns the last path component.
    ///
    /// Some examples are below:
    ///
    /// - `refs/stash` → `stash`
    /// - `refs/heads/master` → `master`
    /// - `refs/remotes/origin/HEAD` → `HEAD`
    /// - `refs/remotes/origin/feature/git` → `origin/feature/git`
    /// - `refs/remotes/origin/feature/major/git` → `origin/feature/major/git`
    var shortName: String { get }
    
    /// A local reference name
    ///
    /// Returns a reference name by removing `"refs"` and the second component from the path (for instance, `"refs/heads"` or `"refs/pull"`). If a reference belongs to a remote, a remote name will be also removed. If the path contains only two components, returns the last path component.
    ///
    /// Some examples are below:
    ///
    /// - `refs/stash` → `stash`
    /// - `refs/heads/master` → `master`
    /// - `refs/remotes/origin/HEAD` → `HEAD`
    /// - `refs/remotes/origin/feature/git` → `feature/git`
    /// - `refs/remotes/origin/feature/major/git` → `feature/major/git`
    var localName: String { get }

    /// A name of a remote. If a path is not a remote path, the resulting string will be empty.
    ///
    /// Some examples are below:
    ///
    /// - `refs/stash` → ``
    /// - `refs/heads/master` → ``
    /// - `refs/remotes/origin/HEAD` → `origin`
    /// - `refs/remotes/origin/feature/git` → `origin`
    var remoteName: String { get }
    
    /// The last path component of a reference name
    ///
    /// Some examples are below:
    ///
    /// - `refs/stash` → `stash`
    /// - `refs/heads/master` → `master`
    /// - `refs/remotes/origin/HEAD` → `HEAD`
    /// - `refs/remotes/origin/feature/git` → `git`
    var lastName: String { get }
}

// MARK: - Comparison
public func == (lhs: RepositoryReferenceName, rhs: RepositoryReferenceName) -> Bool {
    return lhs.fullName == rhs.fullName
}

public func != (lhs: RepositoryReferenceName, rhs: RepositoryReferenceName) -> Bool {
    return !(lhs == rhs)
}
