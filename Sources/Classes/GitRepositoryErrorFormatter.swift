//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class GitRepositoryErrorFormatter {
    
    class func message(gitError error: GitError) -> String {
        switch error {
        case .cherryPickCouldNotApplyChange(let message):
            return "[GIT.framework] RE0300: A changeset has been reintegrated, but a conflict occured. Error says: '\(message)'"
            
        default:
            return error.rawMessage
        }
    }
    
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
            
        case .repositoryInvalidGitDirectory(let atPath):
            return "[GIT.framework] RE0041: Not a git repository at path: \(atPath). .git directory does not exist"
            
        case .cloneErrorDirectoryIsNotEmpty(let atPath):
            return "[GIT.framework] RE0050: Unable to clone a repository at '\(atPath)'. Path is not empty."
            
        case .unableToCreateTemporaryPath:
            return "[GIT.framework] RE0070: Unable to create a temporary directory on the local machine."
            
        case .unableToApplyStashRecordNotFound(let record):
             return "[GIT.framework] RE0180: An error occurred while trying to apply a stash record \(record.shortHash). It seems this stash record no longer exists"
                        
        case .unableToDropStashRecordNotFound(let record):
            return "[GIT.framework] RE0200: An error occurred while trying to drop a stash record \(record.shortHash). It seems this stash record no longer exists"
                        
        case .pullFallenRemotesNotFound:
            return "[GIT.framework] RE0220: Unable to pull on this repository. Remotes are not set up. Please make sure at least one remote is set."
                        
        case .thereIsNoMergeToAbort:
            return "[GIT.framework] RE0235: Unable to abort merge on this repository. There is no merge to abort."
                    
        case .mergeFinishedWithConflicts:
            return "[GIT.framework] RE0250: Merge operation has been finished, but conflicts have been detected."
        
        case .branchNotFound(let branchName):
            return "[GIT.framework] RE0350: Branch with the given name \(branchName) has not been found."
            
        case .repositoryCreateInvalidPath:
            return "[GIT.framework] RE1000: Can not initialize a new repository at the given path. Path is invalid."
            
        case .repositoryCreatePathNotExists:
            return "[GIT.framework] RE1010: Can not initialize a new repository at the given path. The given path does not exist."
        }
    }
}
