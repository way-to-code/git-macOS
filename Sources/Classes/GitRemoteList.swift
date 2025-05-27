//
//  GitReference.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public class GitRemoteList {
    
    // MARK: - Private
    private(set) public var remotes: [RepositoryRemote]
    
    // MARK: - Public
    required init(remotes: [RepositoryRemote]) {
        self.remotes = remotes
    }
    
    /// Returns the origin remote (if it presents in the list)
    public var origin: RepositoryRemote? {
        get {
            return remotes.first(where: {$0.name == "origin"})
        }
    }
}

// MARK: - IndexSequence
extension GitRemoteList: IndexSequence {

    subscript(index: Int) -> Any? {
        get {
            return remotes.count > index ? remotes[index] : nil
        }
    }
}

// MARK: - Sequence
extension GitRemoteList: Sequence {
    
    var count: Int {
        return remotes.count
    }
    
    subscript(index: Int) -> RepositoryRemote? {
        get {
            return remotes.count > index ? remotes[index] : nil
        }
    }
    
    public func makeIterator() -> IndexIterator<RepositoryRemote> {
        return IndexIterator<RepositoryRemote>(collection: self)
    }
}
