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
    
    /// Initializes a new empty repository at the given path.
    /// - Parameters:
    ///   - path: A path on the local machine where a new repository will be created
    ///   - options: A set of options for git init command.
    ///
    /// The specified path must exist, otherwise an exception is raized
    static func create(atPath path: String,
                       options: GitInitOptions = .default,
                       using credentials: CredentialsProvider = GitCredentialsProvider.anonymousProvider) throws -> GitRepository {
        switch FileManager.checkFile(at: URL(fileURLWithPath: path)) {
        case .exists(isDirectory: true):
            break
            
        case .exists(isDirectory: false):
            throw RepositoryError.repositoryCreateInvalidPath
            
        case .notExists:
            throw RepositoryError.repositoryCreatePathNotExists
        }
        
        let repository = GitRepository(atEmptyPath: path, using: credentials)

        // Validate a branch name if it was provided
        if let branchName = options.initialBranchName {
            let validateTask = CheckRefFormatTask(owner: repository,
                                                  options: ["--branch", branchName])
            
            do {
                try validateTask.run()
            } catch {
                throw GitError.invalidBranchName(name: branchName, message: validateTask.message)
            }
        }
        
        let task = InitTask(owner: repository, options: options)
        try task.run()
        
        return repository
    }
}
