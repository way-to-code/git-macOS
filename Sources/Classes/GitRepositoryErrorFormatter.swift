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
            return "[GIT.framework] RE0010: An attempt to perform an operation on repository when active operation already in progress."
            
        case .repositoryNotInitialized:
            return "[GIT.framework] RE0020: An attempt to perform an operation on repository which is not initialized yet. Please initialize the repository with remote URL or local path."
            
        case .repositoryHasBeenAlreadyCloned:
            return "[GIT.framework] RE0030: An attempt to clone a repository that has been already cloned. Please create a new instance of repository and try to clone it again"
            
        case .repositoryLocalPathNotExists:
            return "[GIT.framework] RE0040: Local path for the repository is no longer valid."
            
        case .cloneErrorDirectoryIsNotEmpty(let atPath):
            return "[GIT.framework] RE0050: Unable to clone a repository at '\(atPath)'. Path is not empty."
            
        case .cloneError(let message):
            return "[GIT.framework] RE0060: An error occurred during cloning a repository. Error says: '\(message)'"
            
        case .unableToCreateTemporaryPath:
            return "[GIT.framework] RE0070: Unable to create a temporary directory on the local machine."
            
        case .checkoutError(let message):
            return "[GIT.framework] RE0080: An error occurred during checking out branch. Error says: '\(message)'"
            
        case .fetchError(let message):
            return "[GIT.framework] RE0090: An error occurred during fetch operation. Error says: '\(message)'"
            
        case .unableToListRemotes(let message):
            return "[GIT.framework] RE0100: An error occurred during listing remotes operation. Error says: '\(message)'"
            
        case .unableToRenameRemote(let message):
            return "[GIT.framework] RE0110: An error occurred during renaming a remote. Error says: '\(message)'"
            
        case .commitError(let message):
            return "[GIT.framework] RE0120: An error occurred during committing changes. Error says: '\(message)'"

        case .pushError(let message):
            return "[GIT.framework] RE0130: An error occurred during pushing changes. Error says: '\(message)'"
            
        case .unableToChangeRemoteURL(let message):
            return "[GIT.framework] RE0140: An error occurred while trying to change and url of a remote. Error says: '\(message)'"
            
        case .stashError(let message):
            return "[GIT.framework] RE0150: An error occurred while trying to create a new stash. Error says: '\(message)'"
            
        case .stashApplyError(let message):
            return "[GIT.framework] RE0160: An error occurred while trying to apply a stash to a working copy. Error says: '\(message)'"
            
        case .stashApplyConflict(let message):
            return "[GIT.framework] RE0170: A conflict has been detected while trying to apply a stash. Error says: '\(message)'"
            
        case .unableToApplyStashRecordNotFound(let record):
             return "[GIT.framework] RE0180: An error occurred while trying to apply a stash record \(record.shortHash). It seems this stash record no longer exists"
            
        case .stashDropError(let message):
            return "[GIT.framework] RE0190: An error occurred while trying to drop a stash record. Error says: '\(message)'"
            
        case .unableToDropStashRecordNotFound(let record):
            return "[GIT.framework] RE0200: An error occurred while trying to drop a stash record \(record.shortHash). It seems this stash record no longer exists"
            
        case .pullError(let message):
            return "[GIT.framework] RE0210: An error occurred while pulling data. Error says: '\(message)"
            
        case .pullFallenRemotesNotFound:
            return "[GIT.framework] RE0220: Unable to pull on this repository. Remotes are not set up. Please make sure at least one remote is set."
        }
    }
}
