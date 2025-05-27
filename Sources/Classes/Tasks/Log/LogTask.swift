//
//  ArgumentConvertible.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class LogTask: RepositoryTask, TaskRequirable {
    var name: String {
        return "log"
    }
    
    private(set) var records = GitLogRecordList([])
    
    required override init(owner: GitRepository, options: ArgumentConvertible) {
        super.init(owner: owner, options: [])
        
        let writer = GitFormatEncoder()
        writer.percentEscapingStrategy = .wrapWithQuotes
        writer.hash = "%H"
        writer.shortHash = "%h"
        writer.authorName = "%an"
        writer.authorEmail = "%ae"
        writer.subject = "%s"
        writer.parentHashes = "%P"
        
        // raw body (unwrapped subject and body)
        // in case using just %b, all newlines will be cut off from the resulting body
        writer.body = "%B"
        
        // strict ISO 8601 format
        writer.commiterDate = "%cI"
        writer.refNames = "%D"
        
        add([writer.encode()])
        add(options.toArguments())
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if terminationStatus == 0, let output = output {
            let decoder = GitFormatDecoder()
            let objects: [GitLogRecord] = decoder.decode(output)
            
            records = GitLogRecordList(objects)
        }
    }
}
