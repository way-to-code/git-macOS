//
//  GitTagOptions.swift
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

/// A set of options that are used for the tagging operation
public enum GitTagOptions: ArgumentConvertible {
    /// Makes an unsigned, annotated tag object with the given name and message.
    /// Optionally, you can specify the exact commit hash from that a tag should be created.
    /// If no commit hash is provided, a tag will be created from HEAD by the default.
    case annotate(tag: String, message: String, commitHash: String? = nil)
    
    /// Deletes the existing tag with the given name
    case delete(tag: String)
    
    /// Creates a lightweight tag that points directly at the given commit hash (if provided).
    case lightWeight(tag: String, commitHash: String? = nil)
    
    /// List tags. With optional pattern matching
    case list(pattern: String?)

    func toArguments() -> [String] {
        switch self {
        case let .annotate(tag, message, commit):
            return ["-a", tag, "-m", message, commit].compactMap { $0 }

        case .delete(let tag):
            return ["-d", tag]

        case let .lightWeight(tag, commit):
            return [tag, commit].compactMap { $0 }

        case .list(let pattern):
            return ["-l", pattern].compactMap { $0 }
        }
    }
}
