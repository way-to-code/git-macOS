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

import Cocoa

extension RepositoryError: LocalizedError {
    
    public var errorDescription: String? {
        return GitRepositoryErrorFormatter.message(from: self)
    }
}

class GitRepositoryErrorFormatter {
    
    class func message(from error: RepositoryError) -> String {
        switch error {
        case .activeOperationInProgress:
            return "[GIT.framework] RE0001: An attempt to perform an operation on repository when active operation already in progress."
            
        case .repositoryNotInitialized:
            return "[GIT.framework] RE0002: An attempt to perform an operation on repository which is not initialized yet. Please initialize the repository with remote URL or local path."
            
        case .repositoryHasBeenAlreadyCloned:
            return "[GIT.framework] RE0003: An attempt to clone a repository that has been already cloned. Please create a new instance of repository and try to clone it again"
            
        case .repositoryLocalPathNotExists:
            return "[GIT.framework] RE0004: Local path for the repository is no longer valid."
            
        case .cloneErrorDirectoryIsNotEmpty(let atPath):
            return "[GIT.framework] RE0005: Unable to clone a repository at '\(atPath)'. Path is not empty."
            
        case .cloneError(let message):
            return "[GIT.framework] RE0006: An error occurred during cloning a repository. Error says: '\(message)'"
            
        case .unableToCreateTemporaryPath:
            return "[GIT.framework] RE0007: Unable to create a temporary directory on the local machine."
            
        case .checkoutError(let message):
            return "[GIT.framework] RE0008: An error occurred during checking out branch. Error says: '\(message)'"
            
        case .fetchError(let message):
            return "[GIT.framework] RE0009: An error occurred during fetch operation. Error says: '\(message)'"
            
        case .unableToListRemotes(let message):
            return "[GIT.framework] RE0010: An error occurred during listing remotes operation. Error says: '\(message)'"
            
        case .unableToRenameRemote(let message):
            return "[GIT.framework] RE0011: An error occurred during renaming a remote. Error says: '\(message)'"
        }
    }
}
