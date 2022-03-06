//
//  TagTask.swift
//  Git-macOS
//
//  Created by Jeremy Greenwood on 1/13/22.
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
