//
//  GitRepository.swift
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

public class GitRepository: Repository {

    // MARK: - Repository
    public weak var delegate: RepositoryDelegate?
    
    private(set) public var localPath: String?
    private(set) public var remoteURL: URL?
    private(set) public var credentialsProvider: CredentialsProvider
    private var isTemporaryPath = false
    
    required public init(from remoteURL: URL,
                         using credentialsProvider: CredentialsProvider = GitCredentialsProvider.anonymousProvider) {
        self.remoteURL = remoteURL
        self.credentialsProvider = credentialsProvider
    }
    
    required public init?(at localPath: String,
                          using credentialsProvider: CredentialsProvider = GitCredentialsProvider.anonymousProvider) {
        self.localPath = localPath
        self.credentialsProvider = credentialsProvider
        
        do {
            try validateLocalPath()
        } catch {
            // unable to create a repository
            return nil
        }
    }
    
    deinit {
        if isTemporaryPath {
            cleanupTemporaryPath()
        }
    }
    
    public func clone(at localPath: String, options: GitCloneOptions = GitCloneOptions.default) throws {
        // check a repository is not cloned yet
        try ensureNotClonedAlready()
        // check for an active operation
        try ensureNoActiveOperations()
        // check a valid path for cloning
        try ensureDirectoryIsEmpty(at: localPath)
        
        guard let remoteURL = remoteURL else {
            // fallback, due to no remote path
            throw RepositoryError.repositoryNotInitialized
        }
        
        // add credentials to string using the provider
        let url = try credentialsProvider.urlByAddingCredentials(to: remoteURL)
        
        // run a task
        let task = CloneTask(to: localPath,
                             from: url.absoluteString,
                             owner: self,
                             options: options)
        try task.run()
        
        // store local cloned path of the repo
        self.localPath = localPath
    }
    
    public func cloneAtTemporaryPath(options: GitCloneOptions = GitCloneOptions.default) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        let temporaryPath = try FileManager.createTemporaryDirectory()
        isTemporaryPath = true
        
        do {
            try clone(at: temporaryPath, options: options)
        } catch {
            // in case the clone fallen, clean up
            cleanupTemporaryPath()
            throw error
        }
    }
    
    private func cleanupTemporaryPath() {
        guard let path = localPath else {
            return
        }
        FileManager.removeDirectory(at: path)
    }
    
    public func fetchReferences() throws -> [RepositoryReference] {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = ReferencesTask(owner: self)
        try task.run()
        
        return task.references
    }
    
    public func cancel() {
        activeTask?.cancel()
        activeTask = nil
    }
    
    // MARK: - Private
    var activeTask: RepositoryTask?
}

// MARK: - Internal
extension GitRepository {
    func ensureNoActiveOperations() throws {
        guard activeTask == nil else {
            throw RepositoryError.activeOperationInProgress
        }
    }
    
    func ensureDirectoryIsEmpty(at localPath: String) throws {
        var isDirectory = ObjCBool(true)
        _ = FileManager.default.fileExists(atPath: localPath, isDirectory: &isDirectory)
        
        if isDirectory.boolValue {
            // in case the specified path is directory, check it is empty
            let content = (try? FileManager.default.contentsOfDirectory(atPath: localPath)) ?? []
            
            guard content.count == 0 else {
                throw RepositoryError.cloneErrorDirectoryIsNotEmpty(atPath: localPath)
            }
        }
    }
    
    func ensureNotClonedAlready() throws {
        if localPath != nil {
            throw RepositoryError.repositoryHasBeenAlreadyCloned
        }
    }
    
    func validateLocalPath() throws {
        guard let localPath = localPath else {
            throw RepositoryError.repositoryNotInitialized
        }
        
        guard FileManager.default.fileExists(atPath: localPath) else {
            throw RepositoryError.repositoryLocalPathNotExists
        }
    }
    
    func outputByRemovingSensitiveData(from output: String) -> String {
        // # remove leading and trailing newlines
        let output = output.trimmingCharacters(in: .newlines)
        
        var replacingWith = ""
        let escapedPassword = credentialsProvider.escapedPassword

        for _ in escapedPassword {
            replacingWith += "*"
        }
        
        // # remove passwords
        return output.replacingOccurrences(of: escapedPassword, with: replacingWith)
    }
}
