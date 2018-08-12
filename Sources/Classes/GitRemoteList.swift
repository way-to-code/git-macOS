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
