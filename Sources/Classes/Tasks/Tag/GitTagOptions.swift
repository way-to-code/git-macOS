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

public enum GitTagOptions: ArgumentConvertible {
    case annotate(_ tag: String, _ message: String)
    case delete(_ tag: String)
    case lightWeight(_ tag: String)
    case list(_ pattern: String?)

    func toArguments() -> [String] {
        switch self {
        case let .annotate(tag, message): return ["-a", "\(tag)", "-m", "\(message)"]
        case .delete(let tag): return ["-d", "\(tag)"]
        case .lightWeight(let tag): return ["\(tag)"]
        case .list(let search):
            guard let search = search else {
                return ["-l"]
            }

            return ["-l", "\(search)"]
        }
    }
}
