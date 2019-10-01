//
//  ReferencesTask.swift
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

class ReferencesTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "for-each-ref"
    }
    
    private(set) var references = [RepositoryReference]()
    
    override init(owner: GitRepository) {
        super.init(owner: owner)
        workingPath = repository.localPath
        
        let writer = GitFormatEncoder()
        writer.path = "refname"
        writer.id = "objectname"
        writer.author = "authorname"
        writer.parentId = "parent"
        writer.date = "creatordate:iso8601-strict"
        writer.message = "contents"
        writer.active = "%(if)%(HEAD)%(then)true%(else)false%(end)"
        
        add([writer.encode()])
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus == 0, let output = self.output {
            let decoder = GitFormatDecoder()
            let objects: [GitReference] = decoder.decode(output)
            
            references.append(contentsOf: objects)
        }
    }
}
