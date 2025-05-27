//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

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
            let urlTask = RemoteUrlTask(owner: self, remoteName: remoteName)
            try urlTask.run()
            
            guard let url = urlTask.remoteUrls.first else { continue }
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
        
        let task = RemoteUrlChangeTask(owner: self, remote: remote, url: newURL)
        try task.run()
    }
}
