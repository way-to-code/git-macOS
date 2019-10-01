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
    
    /// Sets up a default path where git executable is located.
    ///
    /// By default /usr/bin/git is used
    ///
    /// - Parameter path: A new path to the git executable application
    public static func installExecutablePath(_ path: String) {
        RepositoryTask.executablePath = path
    }
    
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
    
    @discardableResult
    public func stashCreate(options: GitStashOptions = GitStashOptions.default) throws -> RepositoryStashRecord? {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        // before stash is created, get the list of records in order to compare the number of records
        let recordsBefore = try listStashRecords()
        
        let task = StashTask(owner: self, options: options)
        try task.run()
        
        let recordsAfter = try listStashRecords()
        
        guard recordsAfter.records.count > recordsBefore.records.count else {
            /// a new record is not created (probably, nothing to stash)
            return nil
        }
        
        guard let record = recordsAfter.records.first else {
            throw RepositoryError.stashError(message: "Unable to retreive a newly created record from repository")
        }
        
        return record
    }
    
    public func commit(options: GitCommitOptions) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = CommitTask(owner: self, options: options)
        try task.run()
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
    
    public func fetchRemotes(options: GitFetchOptions = GitFetchOptions.default) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = FetchTask(owner: self, options: options)
        try task.run()
    }
    
    public func listLogRecords(options: GitLogOptions = GitLogOptions.default) throws -> GitLogRecordList {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = LogTask(owner: self, options: options)
        try task.run()
        
        return task.records
    }
    
    public func listStashRecords() throws -> GitStashRecordList {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = StashListTask(owner: self, options: GitStashListOptions())
        try task.run()
        
        return task.records
    }
    
    public func listPendingLogRecords(comparedTo remote: RepositoryRemote) throws -> GitLogRecordList {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let references = try listReferences()
        guard let activeReference = references.currentReference else {
            // fallback, as the current reference can not be obtained
            return GitLogRecordList([])
        }
        
        let logOptions = GitLogOptions()
        logOptions.compareReference =
            GitLogOptions.ReferenceComparator(strategy: .compareRemoteWithLocal,
                                              remoteReference: "\(remote.name)/\(activeReference.name)", localReference: activeReference.name)
        
        return try listLogRecords(options: logOptions)
    }
    
    public func fetchUpcomingLogRecords(comparedTo remote: RepositoryRemote) throws -> GitLogRecordList {
        return try fetchUpcomingLogRecords(comparedTo: remote, fetch: true)
    }
    
    public func listUpcomingLogRecords(comparedTo remote: RepositoryRemote) throws -> GitLogRecordList {
        return try fetchUpcomingLogRecords(comparedTo: remote, fetch: false)
    }
    
    public func listReferences() throws -> GitReferenceList {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = ReferencesTask(owner: self)
        try task.run()
        
        return GitReferenceList(task.references)
    }
    
    public func listRemotes() throws -> GitRemoteList {
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
    
    public func checkout(reference: RepositoryReference) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = CheckoutTask(reference: reference, owner: self)
        try task.run()
    }
    
    public func pull(options: GitPullOptions = GitPullOptions.default) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        // # ensure a repository has at least one remote
        guard let remotes = try? listRemotes() else {
            throw RepositoryError.pullFallenRemotesNotFound
        }
        
        guard remotes.remotes.count > 0 else {
            throw RepositoryError.pullFallenRemotesNotFound
        }
        
        // # pull
        let task = PullTask(owner: self, options: options)
        try task.run()
    }
    
    public func push(options: GitPushOptions = GitPushOptions.default) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = PushTask(owner: self, options: options)
        try task.run()
    }
    
    public func stashApply(options: GitStashApplyOptions = .default) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        var resultingOptions = options
        
        if let record = options.stash {
            // a record is provided, validate it exists in the list
            
            guard let foundRecord = stashRecord(from: record) else {
                // fallback as the record has not been found
                throw RepositoryError.unableToApplyStashRecordNotFound(record: record)
            }
            
            // a stash index may be changed after the stash is done, adjust it
            resultingOptions = options.clone(options: options, for: foundRecord)
        }
        
        // apply a stash
        let task = StashApplyTask(owner: self, options: resultingOptions)
        try task.run()
    }
    
    public func stashDrop(record: RepositoryStashRecord?) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        var resultingRecord = record
        
        if let record = record {
            guard let foundRecord = stashRecord(from: record) else {
                // fallback as the record has not been found
                throw RepositoryError.unableToDropStashRecordNotFound(record: record)
            }
            
            resultingRecord = foundRecord
        }
        
        // run the dro task
        let task = StashDropTask(owner: self, options: GitStashDropOptions(stash: resultingRecord))
        try task.run()
        
    }
    
    public func cancel() {
        activeTask?.cancel()
        activeTask = nil
    }
    
    // MARK: - Private
    var activeTask: RepositoryTask?
}

// MARK: - Internal (Remotes)
extension GitRepository {
    
    /// Renames the specified remote to a new name
    func renameRemote(_ remote: GitRemote, to name: String) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = RemoteRenameTask(owner: self, remote: remote, name: name)
        try task.run()
    }
    
    /// Changes an url of a remote to a new URL
    func changeRemoteURL(_ remote: GitRemote, to newURL: URL) throws {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        let task = RemoteURLChangeTask(owner: self, remote: remote, url: newURL)
        try task.run()
    }
}

// MARK: - Internal (Stash)
extension GitRepository {

    /// Searches an actual stash record in repository by the specified stash record
    fileprivate func stashRecord(from record: RepositoryStashRecord) -> RepositoryStashRecord? {
        // first of all, get stash list
        guard let stashlist = try? listStashRecords() else {
            return nil
        }
        
        // find a record by a hash
        guard let foundRecord = stashlist.records.first(where: { $0.hash == record.hash }) else {
            // fallback as the record has not been found
            return nil
        }
        
        return foundRecord
    }
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
        let escapedPassword = credentialsProvider.escapedPassword ?? ""

        for _ in escapedPassword {
            replacingWith += "*"
        }
        
        // # remove passwords
        return output.replacingOccurrences(of: escapedPassword, with: replacingWith)
    }
    
    fileprivate func fetchUpcomingLogRecords(comparedTo remote: RepositoryRemote, fetch: Bool) throws -> GitLogRecordList {
        // check for an active operation
        try ensureNoActiveOperations()
        
        // local path must be valid
        try validateLocalPath()
        
        // before listing, fetch a remote
        if fetch {
            try fetchRemotes()
        }
        
        let references = try listReferences()
        guard let activeReference = references.currentReference else {
            // fallback, as the current reference can not be obtained
            return GitLogRecordList([])
        }
        
        let logOptions = GitLogOptions()
        logOptions.compareReference =
            GitLogOptions.ReferenceComparator(strategy: .compareLocalWithRemote,
                                              remoteReference: "\(remote.name)/\(activeReference.name)", localReference: activeReference.name)
        
        return try listLogRecords(options: logOptions)
        
    }
}
