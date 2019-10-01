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

class LogTask: RepositoryTask, TaskRequirable {
    var name: String {
        return "log"
    }
    
    private(set) var records = GitLogRecordList([])
    
    required init(owner: GitRepository, options: ArgumentConvertible) {
        super.init(owner: owner)
        workingPath = repository.localPath
        
        let writer = GitFormatEncoder()
        writer.percentEscapingStrategy = .wrapWithQuotes
        writer.hash = "%H"
        writer.shortHash = "%h"
        writer.authorName = "%an"
        writer.authorEmail = "%ae"
        writer.subject = "%s"
        
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
