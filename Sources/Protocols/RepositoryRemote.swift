//
//  RepositoryReference.swift
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

/// Describes a remote in a repository
public protocol RepositoryRemote {

    /// A name of a remote in repository
    var name: String { get }
    
    /// URL to this remote
    var url: URL { get }
    
    /// Renames a remote to the new specified name. Changes are immediatelly applied to repository.
    ///
    /// - Parameter name: A new name to use for this remote.
    /// - Throws: An exception if a rename operation has been fallen
    mutating func rename(to name: String) throws
    
    /// Changes a remote URL for this remote. See git remote set-url command for details
    ///
    /// - Parameter url: A new URL of a remote
    mutating func changeURL(to newUrl: URL) throws
}
