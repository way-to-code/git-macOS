//
//  GitMergeStatus.swift
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

/// Current merge statis of a repository
public class GitMergeStatus {
    
    internal init() {    
    }
    
    /// Determines whether an active merge is in progress in a repository
    public internal(set) var isMergeInProgress: Bool = false
    
    /// Determines whether an active squash is in progress in a repository
    public internal(set) var isSquashInProgress: Bool = false
}
