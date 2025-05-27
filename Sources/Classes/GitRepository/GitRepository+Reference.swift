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
        guard let reference = references.localBranches.first(where: {$0.name.localName == branchName}) else {
            throw RepositoryError.branchNotFound(name: branchName)
        }
        
        return reference
    }
}
