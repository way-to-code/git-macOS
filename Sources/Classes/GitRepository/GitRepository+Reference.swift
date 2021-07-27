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
    
    @discardableResult
    func createBranch(branchName: String, options: GitBranchOptions) throws -> RepositoryReference {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        // Validate a branch name is a valid name
        let validateTask = CheckRefFormatTask(owner: self, options: ["--branch", branchName])
        
        do {
            try validateTask.run()
        } catch {
            throw GitError.invalidBranchName(name: branchName, message: validateTask.message)
        }
        
        // Run the branch task
        let task = BranchTask(branchName: branchName, owner: self, options: options)
        try task.run()
        
        // Get a reference to the branch
        let references = try listReferences()
        guard let reference = references.localBranches.first(where: {$0.name == branchName}) else {
            throw RepositoryError.branchNotFound(name: branchName)
        }
        
        return reference
    }
}
