//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
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

public extension GitRepository {
    
    func listRemotes() throws -> GitRemoteList {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        // load the list of remotes in a repository
        let listRemotesTask = RemoteListTask(owner: self)
        try listRemotesTask.run()
        
        var remotes = [GitRemote]()
        
        // and then obtain an additional information
        for remoteName in listRemotesTask.remoteNames {
            let urlTask = RemoteURLTask(owner: self, remoteName: remoteName)
            try urlTask.run()
            
            guard let url = urlTask.remoteURLs.first else { continue }
            let remote = GitRemote(name: remoteName, url: url, repository: self)
            remotes.append(remote)
        }

        return GitRemoteList(remotes: remotes)
    }
    
    @discardableResult
    func addRemote(name: String, url: URL) throws -> RepositoryRemote {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let task = RemoteAddTask(owner: self, name: name, url: url)
        try task.run()
        
        return GitRemote(name: name, url: url, repository: self)
    }
    
    /// Renames the specified remote to a new name
    internal func renameRemote(_ remote: GitRemote, to name: String) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = RemoteRenameTask(owner: self, remote: remote, name: name)
        try task.run()
    }
    
    /// Changes an url of a remote to a new URL
    internal func changeRemoteURL(_ remote: GitRemote, to newURL: URL) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = RemoteURLChangeTask(owner: self, remote: remote, url: newURL)
        try task.run()
    }
}
