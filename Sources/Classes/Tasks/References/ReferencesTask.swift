//
//  ReferencesTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class ReferencesTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "for-each-ref"
    }
    
    private(set) var references = [RepositoryReference]()
    
    required init(owner: GitRepository) {
        super.init(owner: owner, options: [])
        
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
