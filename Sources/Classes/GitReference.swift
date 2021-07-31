//
//  GitReference.swift
//  Git-macOS
//
//  Copyright (c) 2018 Max A. Akhmatov
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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

