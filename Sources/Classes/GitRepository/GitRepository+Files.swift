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
    
    func add(files: [String], options: GitAddOptions = .default) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        options.addFiles(files)
        
        let task = AddTask(owner: self, options: options)
        try task.run()
    }
    
    func addWithStatusCheck(files: [String], options: GitAddOptions = .default) throws -> GitFileStatusList {
        try add(files: files)
        
        let statusOptions = GitStatusOptions()
        statusOptions.addFiles(files)
        
        return try listStatus(options: statusOptions)
    }
    
    func reset(files: [String]) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let options = GitResetOptions()
        options.files = files
        
        let task = ResetTask(owner: self, options: options)
        try task.run()
    }
    
    func resetWithStatusCheck(files: [String]) throws -> GitFileStatusList {
        try reset(files: files)
        
        let statusOptions = GitStatusOptions()
        statusOptions.addFiles(files)
        
        return try listStatus(options: statusOptions)
    }
    
    func discardChanges(in files: [String]) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        // #1. Reset all index changes
        try reset(files: files)
        
        // #2. Reset all changes in worktree
        let checkoutOptions = GitCheckoutOptions(files: files)
        
        let checkoutTask = CheckoutTask(owner: self, options: checkoutOptions)
        try checkoutTask.run()
    }
    
    func discardAllLocalChanges() throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        // #1. Reset all index changes. All changes from index will be moved to worktree
        let resetOptions = GitResetOptions()
        resetOptions.mode = .hard
        
        let task = ResetTask(owner: self, options: resetOptions)
        try task.run()
        
        // #2. Reset all worktree changes.
        let checkoutOptions = GitCheckoutOptions()
        checkoutOptions.checkoutAllFiles = true
        
        let checkoutTask = CheckoutTask(owner: self, options: checkoutOptions)
        try checkoutTask.run()
        
        // #3. Remove all untracked files
        let cleanOptions = GitCleanOptions()
        cleanOptions.force = true
        cleanOptions.includeUntrackedSubdirectories = true
        
        let cleanTask = CleanTask(owner: self, options: cleanOptions)
        try cleanTask.run()
    }
}

public extension GitRepository {
    
    enum FileError: Error {
        
        /// Occurs when git add file operation fails
        case unableToAddFiles(message: String)
        
        /// Occurs when git reset file operation fails
        case unableToReset(message: String)
    }
}

extension GitRepository.FileError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .unableToAddFiles(let message):
            return "[GIT.framework] FE0010: Unable to add files. Error says: '\(message)'"
            
        case .unableToReset(let message):
            return "[GIT.framework] FE0020: Unable to reset files. Error says: '\(message)'"
        }
    }
}
