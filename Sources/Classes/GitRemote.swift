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
