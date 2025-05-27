//
//  TagTask.swift
//  Git-macOS
//
//  Copyright (c) Jeremy Greenwood
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class TagTask: RepositoryTask, TaskRequirable {
    var name: String { "tag" }
    var tags = GitTagRecordList([])

    func handle(output: String) {}

    func handle(errorOutput: String) {}

    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            throw GitError.tagError(message: output ?? "Unknown error")
        }

        if let output = output {
            tags = GitTagRecordList(
                output.trimmingCharacters(in: .newlines)
                    .components(separatedBy: "\n")
                    .map(GitTagRecord.init(tag:)))
        }
    }
}
