//
//  Repository.swift
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

/// Generic git error declaration
public protocol GitCommonError: Error {
    
    /// A raw git message returned by the git
    var rawMessage: String { get }
}

/// Specific git errors declarations
public enum GitError: Error {
    
    // MARK: - Checkout
    /// Occurs when the checkout operation finishes with an error
    case checkoutError(message: String)
    
    // MARK: - Clone
    /// Occurs when the clone operation finishes with an error
    case cloneError(message: String)
    
    // MARK: - Clean
    /// Occurs when the clean operation fails
    case cleanError(message: String)
    
    // MARK: - Commit
    /// Occurs when the commit operation finishes with an error
    case commitError(message: String)

    // MARK: - Tag
    /// Occurs when the tag operation finishes with an error
    case tagError(message: String)
    
    // MAKR: - Init
    /// Occurs when the init operation finishes with an error
    case initError(message: String)
    
    // MARK: - Stash
    /// Occurs when a new stash creation is fallen
    case stashError(message: String)
    
    /// Occurs when applying a stash has been fallen
    case stashApplyError(message: String)
    
    /// Occurs when a stash conflict is detected during the stash operation
    case stashApplyConflict(message: String)
    
    /// Occurs when a stash drop operation is fallen
    case stashDropError(message: String)
    
    // MARK: - Fetch
    /// Occurs when the fetch operation finishes with an error
    case fetchError(message: String)
    
    // MARK: - Push
    /// Occurs when the push operation finishes with an error
    case pushError(message: String)
    
    // MARK: - Pull
    /// Occurs when the pull operation finishes with an error
    case pullError(message: String)
    
    // MARK: - Remotes
    /// Occurs when the list remotes operation finishes with an error
    case remoteUnableToList(message: String)
    
    /// Occurs when the remote can not be added
    case remoteUnableToAdd(message: String)
    
    /// Occurs when the rename remote operation finishes with an error
    case remoteUnableToRename(message: String)
    
    /// Occurs when the rename remote operation finishes with an error
    case remoteUnableToChangeURL(message: String)
    
    // MARK: - Merge
    /// Occurs when the merge operation fails
    case mergeHasBeenFallen(message: String)
    
    /// Occurs when merge abort operation has been fallen
    case mergeUnableToAbort(message: String)
    
    // MARK: - CherryPick
    /// Occurs usually when a conflict occurs during the cherry pick operation
    case cherryPickCouldNotApplyChange(message: String)
    
    /// Occurs when the cherry pick operation fails
    case cherryPickHasBeenFallen(message: String)
    
    // MARK: - Cherry
    /// Occurs when cherry operation fails
    case cherryHasBeenFallen(message: String)
    
    // MARK: - Branch
    /// Occurs after a new branch name was not validated by git
    case invalidBranchName(name: String, message: String)
    
    /// Occurs when a new branch can not be greated
    case canNotCreateBranch(name: String, message: String)
}

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
    
    /// Occurs when git repository can not be initialized, because the specified folder does not contain a git repsitory
    case repositoryInvalidGitDirectory(atPath: String)
    
    /// Occurs when a new repository can not be initialized because the path does not exist
    case repositoryCreatePathNotExists
    
    /// Occurs when a new repository can not be initialized becase the path is invalid
    case repositoryCreateInvalidPath
    
    /// Occurs when the clone operation can not be started because the specified path is not an empty folder
    case cloneErrorDirectoryIsNotEmpty(atPath: String)

    /// Occurs when trying to perform a pull operation when no remotes are set up on a repository
    case pullFallenRemotesNotFound
    
    /// Occurs when trying to create a temporary path on the local machine, but fallen
    case unableToCreateTemporaryPath
    
    /// Occurs when stash apply operation has been fallen in case no stash record is found
    case unableToApplyStashRecordNotFound(record: RepositoryStashRecord)
    
    /// Occurs when stash drop operation has been fallen in case no stash record is found
    case unableToDropStashRecordNotFound(record: RepositoryStashRecord)
    
    /// Occuts when the merge operations finishes, but conflicts have been detected
    case mergeFinishedWithConflicts
    
    /// Occurs when merge abort operation can not be started, because the merge is not in progress
    case thereIsNoMergeToAbort
    
    /// Unexpected branch error occured
    case branchNotFound(name: String)
}

// MARK: - GitError + LocalizedError
extension GitError: LocalizedError {
    public var errorDescription: String? {
        GitRepositoryErrorFormatter.message(gitError: self)
    }
}

// MARK: - GitError + GitCommonError
extension GitError: GitCommonError {
    
    public var rawMessage: String {
        switch self {
        case .cleanError(let message): return message
        case .checkoutError(let message): return message
        case .cloneError(let message): return message
        case .commitError(let message): return message
        case .tagError(let message): return message
        case .stashError(let message): return message
        case .stashApplyError(let message): return message
        case .stashApplyConflict(let message): return message
        case .stashDropError(let message): return message
        case .fetchError(let message): return message
        case .pushError(let message): return message
        case .pullError(let message): return message
        case .remoteUnableToList(let message): return message
        case .remoteUnableToAdd(let message): return message
        case .remoteUnableToRename(let message): return message
        case .remoteUnableToChangeURL(let message): return message
        case .mergeHasBeenFallen(let message): return message
        case .mergeUnableToAbort(let message): return message
        case .cherryPickCouldNotApplyChange(let message): return message
        case .cherryPickHasBeenFallen(let message): return message
        case .cherryHasBeenFallen(let message): return message
        case .invalidBranchName(_, let message): return message
        case .canNotCreateBranch(_, let message): return message
        case .initError(let message): return message
        }
    }
}

// MARK: - RepositoryError + LocalizedError
extension RepositoryError: LocalizedError {
    public var errorDescription: String? {
        GitRepositoryErrorFormatter.message(from: self)
    }
}
