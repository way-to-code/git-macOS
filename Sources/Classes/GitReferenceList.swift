//
//  GitReferenceList.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A list that contains all references from a single GitRepository object
public class GitReferenceList {
    
    // MARK: - Public
    required public init(_ references: [RepositoryReference]) {
        self.references = references
    }
    
    /// Returns the current (active reference in this repository (if any)
    public var currentReference: RepositoryReference? {
        return references.first(where: {$0.active})
    }
    
    /// Only local branches from this list or an empty array
    public var localBranches: [RepositoryReference] {
        return objects(startingFrom: GitReference.RefPath.Heads)
    }
    
    /// Only remote branches from this list or an empty array
    public var remoteBranches: [RepositoryReference] {
        return objects(startingFrom: GitReference.RefPath.Remotes)
    }
    
    /// The master branch (if present)
    public var masterBranch: RepositoryReference? {
        return objects(startingFrom: GitReference.RefPath.Master).first
    }
    
    /// Only tags from this list or an empty array
    public var tags: [RepositoryReference] {
        return objects(startingFrom: GitReference.RefPath.Tags)
    }
    
    // MARK: - Private
    private(set) public var references: [RepositoryReference]
}

// MARK: - Private
extension GitReferenceList {
    
    func objects(startingFrom path: String) -> [RepositoryReference] {
        return references.filter({$0.path.starts(with: path)})
    }
    
}

// MARK: - IndexSequence
extension GitReferenceList: IndexSequence {

    subscript(index: Int) -> Any? {
        get {
            return references.count > index ? references[index] : nil
        }
    }
}

// MARK: - Sequence
extension GitReferenceList: Sequence {
    
    var count: Int {
        return references.count
    }
    
    subscript(index: Int) -> RepositoryReference? {
        get {
            return references.count > index ? references[index] : nil
        }
    }
    
    public func makeIterator() -> IndexIterator<RepositoryReference> {
        return IndexIterator<RepositoryReference>(collection: self)
    }
}
