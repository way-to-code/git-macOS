//
//  GitRepository+Tag.swift
//  Git
//
//  Created by Jeremy Greenwood on 1/14/22.
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

public extension GitRepository {
    func tag(options: GitTagOptions) throws {
        // check for an active operation
        try ensureNoActiveOperations()

        // local path must be valid
        try validateLocalPath()

        let task = TagTask(owner: self, options: options)
        try task.run()
    }

    func tagList(pattern: String? = nil) throws -> GitTagRecordList {
        // check for an active operation
        try ensureNoActiveOperations()

        // local path must be valid
        try validateLocalPath()

        let task = TagTask(owner: self, options: GitTagOptions.list(pattern))
        try task.run()

        return task.tags
    }
}
