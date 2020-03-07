//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
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

public extension GitRepository {
    
    func listStatus(options: GitStatusOptions = .default) throws -> GitFileStatusList {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let task = StatusTask(owner: self, options: options)
        try task.run()
        
        return task.status
    }
}
