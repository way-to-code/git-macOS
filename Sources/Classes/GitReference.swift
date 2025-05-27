//
//  GitReference.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class GitReference: RepositoryReference, Codable {
    
    var id: String
    var parentId: String?
    
    var active: Bool
    var author: String
    var date: Date
    var message: String?
    
    var name: RepositoryReferenceName {
        return GitReferenceName(path: path)
    }
    
    var path: String
}

// MARK: - Constants
extension GitReference {
    
    /// Defines contant paths of a reference (the part after $GIT_DIR/)
    enum RefPath: String, CaseIterable {
        case heads = "refs/heads"
        case pull = "refs/pull"
        case remotes = "refs/remotes"
        case stash = "refs/stash"
        case tags = "refs/tags"

        static let Heads = RefPath.heads.rawValue
        static let Pull = RefPath.pull.rawValue
        static let Remotes = RefPath.remotes.rawValue
        static let Stash = RefPath.stash.rawValue
        static let Tags = RefPath.tags.rawValue
        
        static let Master = "refs/heads/master"
        static let Refs = "refs"
        
        static let Separator = "/"
        static let SeparatorCharacterSet = CharacterSet(charactersIn: RefPath.Separator)
    }
}

