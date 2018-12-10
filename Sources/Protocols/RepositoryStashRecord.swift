//
//  RepositoryStashRecord.swift
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

/// Describes a single shash record in a repository
public protocol RepositoryStashRecord: RepositoryLogRecord {
    
    /// An index of this stash record in repository.
    ///
    /// In general, you **must not** count on a value of the property as it may become invalid, for example when stash records are changed outside.
    /// Only the **hash** field can be used to unique identify a stash record.
    var stackIndex: Int { get }
}
