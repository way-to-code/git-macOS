//
//  GitReference.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

struct GitRemote: RepositoryRemote {
    
    // MARK: - Private
    private(set) var name: String
    private(set) var url: URL
    private weak var repository: GitRepository?
    
    // MARK: - Public
    init(name: String, url: URL, repository: GitRepository) {
        self.name = name
        self.url = url
        self.repository = repository
    }
    
    mutating func rename(to name: String) throws {
        try repository?.renameRemote(self, to: name)
        
        // as the remote name is changed, change a name in this reference
        self.name = name
    }
    
    mutating func changeURL(to newUrl: URL) throws {
        try repository?.changeRemoteURL(self, to: newUrl)
        
        self.url = newUrl
    }
}
