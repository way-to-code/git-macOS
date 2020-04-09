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

public enum RepositoryError: Error {
    /// Occurs when trying to perform an operation on repository when active operation already in progress.
    /// If you want to make two or more operations at ones, you can create a new repository instance and do operation here
    case activeOperationInProgress
    
    /// Occurs when trying to perform an operation on a repository that is not cloned or initilized with a localpath
    case repositoryNotInitialized
    
    /// Occurs on an attempt to clone a repository that has been already cloned, or initialized with a local path.
    case repositoryHasBeenAlreadyCloned
    
    /// Occurs when trying to perform an operation on a repository, but a local path no longer exists in the system
    case repositoryLocalPathNotExists
    
    /// Occurs when a new stash creation is fallen
    case stashError(message: String)
    
    /// Occurs when applying a stash has been fallen
    case stashApplyError(message: String)
    
    /// Occurs when a stash conflict is detected during the stash operation
    case stashApplyConflict(message: String)
    
    /// Occurs when a stash drop operation is fallen
    case stashDropError(message: String)
    
    /// Occurs when the clone operation can not be started because the specified path is not an empty folder
    case cloneErrorDirectoryIsNotEmpty(atPath: String)
    
    /// Occurs when the clone operation finishes with an error
    case cloneError(message: String)
    
    /// Occurs when the checkout operation finishes with an error
    case checkoutError(message: String)
    
    /// Occurs when the commit operation finishes with an error
    case commitError(message: String)
    
    /// Occurs when the fetch operation finishes with an error
    case fetchError(message: String)
    
    /// Occurs when the push operation finishes with an error
    case pushError(message: String)
    
    /// Occurs when the pull operation finishes with an error
    case pullError(message: String)
    
    /// Occurs when trying to perform a pull operation when no remotes are set up on a repository
    case pullFallenRemotesNotFound
    
    /// Occurs when the list remotes operation finishes with an error
    case unableToListRemotes(message: String)
    
    /// Occurs when the rename remote operation finishes with an error
    case unableToRenameRemote(message: String)
    
    /// Occurs when the rename remote operation finishes with an error
    case unableToChangeRemoteURL(message: String)
    
    /// Occurs when trying to create a temporary path on the local machine, but fallen
    case unableToCreateTemporaryPath
    
    /// Occurs when stash apply operation has been fallen in case no stash record is found
    case unableToApplyStashRecordNotFound(record: RepositoryStashRecord)
    
    /// Occurs when stash drop operation has been fallen in case no stash record is found
    case unableToDropStashRecordNotFound(record: RepositoryStashRecord)
    
    /// Occurs when the merge operation fails 
    case mergeHasBeenFallen(message: String)
    
    /// Occuts when the merge operations finishes, but conflicts have been detected
    case mergeFinishedWithConflicts
    
    /// Occurs when merge abort operation has been fallen
    case unableToAbortMerge(message: String)
    
    /// Occurs when merge abort operation can not be started, because the merge is not in progress
    case thereIsNoMergeToAbort
    
    /// Occurs usually when a conflict occurs during the cherry pick operation
    case cherryPickCouldNotApplyChange(message: String)
    
    /// Occurs when the cherry pick operation fails
    case cherryPickHasBeenFallen(message: String)
}

/// Common delegate for handling repository events
public protocol RepositoryDelegate: class {
    /// Occurs when a clone operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressClone progress: String)
    
    /// Occurs when a commit operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressCommit progress: String)
    
    /// Occurs when a push operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressPush progress: String)
    
    /// Occurs when a pull operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressPull progress: String)
    
    /// Occurs when a fetch operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    func repository(_ repository: Repository, didProgressFetch progress: String)
    
    /// Occurs when a task is being started
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - arguments: The list of arguments for the starting command
    func repository(_ repository: Repository, willStartTaskWithArguments arguments: [String])
    
    /// Occurs when the merge operation finishes
    /// - Parameters:
    ///   - repository: A repository responsible for an event
    ///   - output: A raw output provided by the merge command
    func repository(_ repository: Repository, didFinishMerge output: String?)
}

public extension RepositoryDelegate {
    func repository(_ repository: Repository, didProgressCommit progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressClone progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressFetch progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressPush progress: String) {
    }
    
    func repository(_ repository: Repository, didProgressPull progress: String) {
    }
    
    func repository(_ repository: Repository, willStartTaskWithArguments arguments: [String]) {
    }
    
    func repository(_ repository: Repository, didFinishMerge output: String?) {
    }
}

/// Describes a single repository object
public protocol Repository: class {
    /// Stores the remote URL to the repository
    var remoteURL: URL? { get }
    
    /// A local path of a repository after it was cloned
    var localPath: String? { get }
    
    var delegate: RepositoryDelegate? { get set }
    
    /// Pointer to the provider repsonsible for credentials
    var credentialsProvider: CredentialsProvider { get }

    /// Initializes a repository with the specified URL
    ///
    /// - Parameters:
    ///   - remoteURL: A remote repository URL
    ///   - credentialsProvider: A provider for credentials
    init(from remoteURL: URL, using credentialsProvider: CredentialsProvider)
    
    /// Tries to initializes a repository with the specified local path
    ///
    /// - Parameters:
    ///   - localPath: A local path to the repository
    ///   - credentialsProvider: A provider for credentials
    init?(at localPath: String, using credentialsProvider: CredentialsProvider)
    
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
    
    /// Creates a working copy of a remote repository locally. Repository must be initialized with a remote URL.
    ///
    /// - Parameters:
    ///   - localPath: A path on the local machine where to clone the contents of the remote repository.
    /// If the specified path doesn't exist in the system yet, it will be created. However, if it exists, it must be an empty directory
    ///   - options: The operation options. Use this if you want to customize the behaviour of the clone operation
    /// - Throws: An exception if a repository can not be copied
    func clone(at localPath: String, options: GitCloneOptions) throws
    
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
    
    /// Lists all remotes in this repository and returns a list object
    ///
    /// - Throws: An exception in case any error occured
    func listRemotes() throws -> GitRemoteList
    
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
