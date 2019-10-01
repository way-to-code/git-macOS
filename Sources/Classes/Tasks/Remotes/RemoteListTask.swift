//
//  ArgumentConvertible.swift
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

import Foundation

class RemoteListTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "remote"
    }
    
    /// The list of remote names obtained by the operation
    private(set) var remoteNames = [String]()
    
    override init(owner: GitRepository) {
        super.init(owner: owner)
        
        workingPath = repository.localPath
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as the fetch was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw RepositoryError.unableToListRemotes(message: output)
        }
        
        // parse remotes. Each remote is divided by a new line
        let remotes = self.output?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
        
        for remoteName in remotes ?? [] {
            remoteNames.append(String(remoteName))
        }
    }
}
