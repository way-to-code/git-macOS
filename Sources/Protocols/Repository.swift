//
//  Repository.swift
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

public protocol Repository: AnyObject {
    
    /// Stores the remote url to the repository
    var remoteUrl: URL? { get }
    
    /// A local path of a repository after it was cloned
    var localPath: String? { get }
    
    var delegate: RepositoryDelegate? { get set }
    
    /// Pointer to the provider repsonsible for credentials
    var credentialsProvider: CredentialsProvider { get }

    /// Initializes a repository with the specified URL
    ///
    /// - Parameters:
    ///   - remoteUrl: A remote repository URL
    ///   - credentialsProvider: A provider for credentials
    init(fromUrl remoteUrl: URL, using credentials: CredentialsProvider)
    
    /// Tries to initializes a repository with the specified local path
    ///
    /// - Parameters:
    ///   - path: A local path to the repository
    ///   - credentialsProvider: A provider for credentials
    init(atPath path: String, using credentialsProvider: CredentialsProvider) throws
    
    /// Add file(s) contents to the index
    /// - Parameters:
    ///   - files: The list of file name to add to the index. Each file must be a file within the repository folder
    ///   - options: The set of options to be uses for the operation
    func add(files: [String], options: GitAddOptions) throws
    
    /// Add file(s) contents to the index and immediatelly retrieves the new status of the files
    /// - Parameters:
    ///   - files: The list of file name to add to the index. Each file must be a file within the repository folder
    ///   - options: The set of options to be uses for the operation
    func addWithStatusCheck(files: [String], options: GitAddOptions) throws -> GitFileStatusList
    
    /// Resets file(s) from the index and moves it to worktree
    /// - Parameter files: The list of file names to remove from the index. Each file must be afile within the repository folder
    func reset(files: [String]) throws
    
    /// Resets file(s) from the index and moves it to worktree and immediatelly retrieves statuses of the given files
    /// - Parameter files: The list of file names to remove from the index. Each file must be afile within the repository folder
    func resetWithStatusCheck(files: [String]) throws -> GitFileStatusList
    
    /// Discards all local uncommitted changes for the given files
    ///
    /// Both files in index and in the worktreee will be reset.
    ///
    /// This operation can not be undone!
    func discardChanges(in files: [String]) throws
    
    /// Discards all local uncommitted changes.
    ///
    /// Both files in index and in worktree will be reset. All untracked files, including subdirectories will be removed.
    ///
    /// This operation leads to all data loss!
    func discardAllLocalChanges() throws
    
    /// Creates a working copy of a remote repository locally. Repository must be initialized with a remote URL.
    ///
    /// - Parameters:
    ///   - path: A path on the local machine where to clone the contents of the remote repository.
    /// If the specified path doesn't exist in the system yet, it will be created. However, if it exists, it must be an empty directory
    ///   - options: The operation options. Use this if you want to customize the behaviour of the clone operation
    /// - Throws: An exception if a repository can not be copied
    func clone(atPath path: String, options: GitCloneOptions) throws
    
    /// Creates a working copy of a remote repository locally at temporary path.
    ///
    ///
    /// Repository will be cloned to a new directory on your local machine created temporarily.
    /// You must ensure that there is enougth space or permissions are granted for writing.
    /// In case a temporary directory can not be created, an exception is raised.
    ///
    /// Temporary directory will be removed as soon as the instance of a Repository object is deallocated.
    /// You can obtain the path to the created directory by using **localPath** property
    ///
    /// - Parameter options: The operation options. Use this if you want to customize the behaviour of the clone operation
    /// - Throws: An exception in case something went wrong
    func cloneAtTemporaryPath(options: GitCloneOptions) throws
    
    /// Creates a new **local** branch in the repository.
    ///
    /// Before a new branch is created, a branch name is validated by git. If a branch can not be created, an exception is raised.
    /// Note that this method will create a new branch, but won't switch working copy to this branch. Use checkout() method in order to switch working copy.
    /// - Parameters:
    ///   - branchName: A name of a new branch to create
    ///   - options: A set of options to be used for the branch creation. Please see GitBranchOptions for more details
    @discardableResult
    func createBranch(branchName: String, options: GitBranchOptions) throws -> RepositoryReference
    
    /// Fetches log records for this repository and the returns the list of fetched records
    ///
    /// - Returns: GitLogRecordList - a list of log records
    /// - Throws: An exception in case something went wrong
    func listLogRecords(options: GitLogOptions) throws -> GitLogRecordList
    
    /// Gets all stash records for this repository and the returns the list of records
    ///
    /// - Returns: GitStashRecordList - a list of stash records
    /// - Throws: An exception in case something went wrong
    func listStashRecords() throws -> GitStashRecordList
    
    /// Compares two references with each other and returns log records difference.
    /// - Parameter options: Options to be used for the comparison.
    ///
    /// Depending on the given options local or remote references will be compared.
    /// When at least one reference participating in the comparison is a remote one, the fetch might occur depending on the fetch strategy specified in the given options.
    func retrieveLogRecordsComparison(options: GitLogCompareOptions) throws -> GitLogRecordList
    
    /// Fetches a list of references in this repository
    ///
    /// - Returns: GitReferenceList - a list of references
    /// - Throws: An exception in case any error occured
    func listReferences() throws -> GitReferenceList
    
    /// Fetches a list of tags from repository
    /// - Parameter options: Addional options that can be used for the listing operation.
    /// - Returns: ``GitTagRecordList`` - a list of tags
    ///
    /// Use this method when you want to retrieve tag names from repository.
    /// If you want to get more details about all references including branches and tags, use ``listReferences()`` method which will return the detailed information about each reference instead of simple tag name.
    func listTags(options: GitTagListOptions) throws -> GitTagRecordList
    
    /// Lists all remotes in this repository and returns a list object
    ///
    /// - Throws: An exception in case any error occured
    func listRemotes() throws -> GitRemoteList
    
    /// Adds a new remote to the repository
    /// - Parameters:
    ///   - name: A name of a remote to be added
    ///   - url: Remote URL
    @discardableResult func addRemote(name: String, url: URL) throws -> RepositoryRemote
    
    /// Lists status of files in repository
    func listStatus(options: GitStatusOptions) throws -> GitFileStatusList
    
    /// Fetches branches and/or tags (collectively, "refs") from a repository, along with the objects necessary to complete their histories
    ///
    /// - Parameter options: The operation options. Use this if you want to customize the behaviour of the fetch operation
    /// - Throws: An exception in case any error occured
    func fetchRemotes(options: GitFetchOptions) throws
    
    /// Switches repository to the specified reference
    ///
    /// - Parameter reference: A reference to that repository should be switched
    /// - Throws: An exception in case switch operation has been fallen
    func checkout(reference: RepositoryReference) throws
    
    /// Commits all local changes in this repository
    ///
    /// - Parameter options: Options for a commit including a commit message
    /// - Throws: An exception in case the operation has been fallen
    func commit(options: GitCommitOptions) throws
    
    /// Fetches data from the remote repository and integrates the changes an active local branch
    ///
    /// - Parameter options: Options for pulling data
    /// - Throws: An exception in case the operation has been fallen
    func pull(options: GitPullOptions) throws
    
    /// Sends data back to a remote repository
    ///
    /// - Parameter options: Options for pushing data
    /// - Throws: An exception in case the operation has been fallen
    func push(options: GitPushOptions) throws
    
    /// Starts a merge process with the given options
    /// - Parameter options: The options used for the merge
    func merge(options: GitMergeOptions) throws
    
    /// Aborts a merge if any.
    ///
    /// When merge is not in progress throws RepositoryError.thereIsNoMergeToAbort
    func mergeAbort() throws
    
    /// Checks the merge status on a repository
    func mergeCheckStatus() throws -> GitMergeStatus
    
    /// Perform the git cherry pick operation
    /// - Parameter options: The options used for the cherry pick
    func cherryPick(options: GitCherryPickOptions) throws
    
    /// Performs the git cherry operation with the given options
    func cherry(options: GitCherryOptions) throws -> GitCherryResult
    
    /// Applies a stash with the specified options to the working copy.
    ///
    /// If no stash options are provided, by default the first stash is applied if possible
    ///
    /// - Parameter options: Options specifying how stash apply should behave
    /// - Throws: An exception in case the operation has been fallen
    func stashApply(options: GitStashApplyOptions) throws
    
    /// Creates a new stash record using the specified options.
    ///
    /// If no stash is created, the method returns nil as a result.
    ///
    /// - Parameter options: The operation options. Use this if you want to customize the behaviour of the stash operation
    /// - Throws: An exception in case stash operation has been fallen
    @discardableResult
    func stashCreate(options: GitStashOptions) throws -> RepositoryStashRecord?
    
    /// Removes a single stash record from repository.
    ///
    /// If no record is provided as an argument, this method will try to remove this latest stash record.
    /// In this case, if no record is deleted, nothing will happen (method won't raise an exception).
    ///
    /// However, in case of providing a record to be dropped, you must ensure, the record still exists in repository, otherwise an exception will be raised.
    ///
    /// - Parameter record: A record to be removed or nil if you want to remove the lastest stash record
    func stashDrop(record: RepositoryStashRecord?) throws
    
    /// Cancels an active repository operation. In case no active operation is started, nothing happens
    func cancel()
}
