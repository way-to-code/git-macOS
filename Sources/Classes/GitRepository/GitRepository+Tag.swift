//
//  GitRepository+Tag.swift
//  Git-macOS
//
//  Copyright (c) Jeremy Greenwood
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public extension GitRepository {
    func tag(options: GitTagOptions) throws {
        // check for an active operation
        try ensureNoActiveOperations()

        // local path must be valid
        try validateLocalPath()

        let task = TagTask(owner: self, options: options)
        try task.run()
    }

    func listTags(options: GitTagListOptions = .default) throws -> GitTagRecordList {
        // check for an active operation
        try ensureNoActiveOperations()

        // local path must be valid
        try validateLocalPath()

        let task = TagTask(owner: self, options: options)
        try task.run()

        return task.tags
    }
}
