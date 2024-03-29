//
//  BranchTask.swift
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
