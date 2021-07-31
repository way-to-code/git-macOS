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
    
    lazy var name: String = {
        if [RefPath.heads, RefPath.remotes, RefPath.tags, RefPath.stash].contains(path) {
            // Drop only "refs"
            return dropPathComponent(RefPath.refs, from: path)
        }
        
        if path.starts(with: RefPath.heads) {
            return dropPathComponent(RefPath.heads, from: path)
        } else if path.starts(with: RefPath.remotes) {
            // In case of remotes, the remote subpath must be also removed
            return dropFirstPathComponent(from: dropPathComponent(RefPath.remotes, from: path))
        } else if path.starts(with: RefPath.tags) {
            return dropPathComponent(RefPath.tags, from: path)
        } else if path.starts(with: RefPath.stash) {
            return dropPathComponent(RefPath.stash, from: path)
        }
        
        return shortName
    }()
    
    lazy var shortName: String = {
        let components = path.components(separatedBy: RefPath.separator)
        
        guard let lastComponent = components.last, lastComponent.count > 0 else {
            return components.count > 1 ? components[components.count - 2] : path
        }
        
        return lastComponent
    }()
    
    var path: String
}

// MARK: - Constants
extension GitReference {
    
    /// Defines contant paths of a reference (the part after $GIT_DIR/)
    struct RefPath {
        static let heads = "refs/heads"
        static let remotes = "refs/remotes"
        static let tags = "refs/tags"
        static let stash = "refs/stash"
        static let master = "refs/heads/master"
        
        static let refs = "refs"
        
        static let separator = "/"
        static let separatorCharacterSet = CharacterSet(charactersIn: RefPath.separator)
    }
    
    fileprivate func dropFirstPathComponent(from path: String) -> String {
        return path.components(separatedBy: RefPath.separator).dropFirst().joined(separator: RefPath.separator)
    }
    
    fileprivate func dropPathComponent(_ component: String, from path: String) -> String {
        let index = path.index(path.startIndex, offsetBy: component.count)
        return String(path[index...]).trimmingCharacters(in: RefPath.separatorCharacterSet)
    }
}


