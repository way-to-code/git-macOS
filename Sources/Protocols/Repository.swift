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

enum RepositoryError: Error {
    /// Occurs when trying to perform an operation on repository when active operation already in progress.
    /// If you want to make two or more operations at ones, you can create a new repository instance and do operation here
    case activeOperationInProgress
    
    /// Occurs when trying to perform an operation on a repository that is not cloned or initilized with a localpath
    case repositoryNotInitialized
    
    /// Occurs on an attempt to clone a repository that has been already cloned, or initialized with a local path.
    case repositoryHasBeenAlreadyCloned
    
    /// Occurs when trying to perform an operation on a repository, but a local path no longer exists in the system
    case repositoryLocalPathNotExists
    
    /// Occurs when the clone operation can not be started because the specified path is not an empty folder
    case cloneErrorDirectoryIsNotEmpty(atPath: String)
    
    /// Occurs when the clone operation finishes with an error
    case cloneError(message: String)
    
    /// Occurs when the checkout operation finishes with an error
    case checkoutError(message: String)
    
    /// Occurs when trying to create a temporary path on the local machine, but fallen
    case unableToCreateTemporaryPath
}

/// Common delegate for handling repository events
public protocol RepositoryDelegate: class {
    /// Occurs when a clone operation receives a progress
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - progress: Output string receved from repository
    func repository(_ repository: Repository, didProgressClone progress: String)
    
    /// Occurs when a task is being started
    ///
    /// - Parameters:
    ///   - repository: A repository reponsible for an event
    ///   - arguments: The list of arguments for the starting command
    func repository(_ repository: Repository, willStartTaskWithArguments arguments: [String])
}

public extension RepositoryDelegate {
    func repository(_ repository: Repository, didProgressClone progress: String) {
    }
    
    func repository(_ repository: Repository, willStartTaskWithArguments arguments: [String]) {
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
    
    /// Fetches a list of references in this repository
    ///
    /// - Returns: GitReferenceList - a list of references
    /// - Throws: An exception in case any error occured
    func fetchReferences() throws -> GitReferenceList
    
    /// Switches repository to the specified reference
    ///
    /// - Parameter reference: A reference to that repository should be switched
    /// - Throws: An exception in case switch operation has been fallen
    func checkout(reference: RepositoryReference) throws
    
    /// Cancels an active repository operation. In case no active operation is started, nothing happens
    func cancel()
}
