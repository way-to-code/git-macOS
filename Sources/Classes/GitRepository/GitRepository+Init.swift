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
    
    /// Initializes a new empty repository at the given path.
    /// - Parameters:
    ///   - path: A path on the local machine where a new repository will be created
    ///   - options: A set of options for git init command.
    ///
    /// The specified path must exist, otherwise an exception is raized
    static func create(atPath path: String,
                       options: GitInitOptions = .default,
                       credentials: CredentialsProvider = GitCredentialsProvider.anonymousProvider) throws -> GitRepository {
        var isDirectory = ObjCBool(true)
        let pathExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)

        guard pathExists else {
            throw RepositoryError.repositoryCreatePathNotExists
        }
        
        guard isDirectory.boolValue else {
            throw RepositoryError.repositoryCreateInvalidPath
        }
        
        guard let repository = GitRepository(atPath: path, using: credentials) else {
            throw RepositoryError.repositoryCreateInvalidPath
        }

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
