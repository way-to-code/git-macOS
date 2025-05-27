//
//  BranchTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class BranchTask: RepositoryTask, TaskRequirable {
    
    // MARK: - Private
    private let branchName: String
    
    // MARK: - Init
    init(branchName: String, owner: GitRepository, options: ArgumentConvertible) {
        self.branchName = branchName
    
        let options = [branchName] + options.toArguments()
        super.init(owner: owner, options: options)
    }
    
    // MARK: - TaskRequirable
    var name: String {
        return "branch"
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus != 0 {
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.canNotCreateBranch(name: branchName, message: output)
        }
    }
}
