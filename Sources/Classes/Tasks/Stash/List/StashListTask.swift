//
//  ArgumentConvertible.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class StashListTask: RepositoryTask, TaskRequirable {
    var name: String {
        return "stash"
    }
    
    private(set) var records = GitStashRecordList([])
    
    required override init(owner: GitRepository, options: ArgumentConvertible) {
        super.init(owner: owner, options: [])
        
        let writer = GitFormatEncoder()
        writer.percentEscapingStrategy = .wrapWithQuotes
        writer.hash = "%H"
        writer.shortHash = "%h"
        writer.authorName = "%an"
        writer.authorEmail = "%ae"
        writer.subject = "%s"
        writer.body = "%b"
        writer.parentHashes = "%P"
        
        // strict ISO 8601 format
        writer.commiterDate = "%cI"
        writer.refNames = "%D"
        
        add(["list"])
        add([writer.encode()])
        add(options.toArguments())
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus == 0, let output = self.output {
            let decoder = GitFormatDecoder()
            let objects: [GitStashRecord] = decoder.decode(output)
            
            // assign a stash index
            for (index, stash) in objects.enumerated() {
                stash.stackIndex = index
            }
            
            records = GitStashRecordList(objects)
        }
    }
}
