//
//  RemoteURLChangeTask.swift
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

class RemoteURLChangeTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "remote"
    }
    
    required init(owner: GitRepository, remote: GitRemote, url: URL) {
        super.init(owner: owner)
        workingPath = repository.localPath
        
        add(["set-url", (remote.name), url.absoluteString])
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as an operation was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw RepositoryError.unableToChangeRemoteURL(message: output)
        }
    }
}
