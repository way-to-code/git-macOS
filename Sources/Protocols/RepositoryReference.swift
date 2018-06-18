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

/// A single reference in a repository
public protocol RepositoryReference {

    /// A unique id of a reference in SHA-1
    var id: String { get }
    
    /// Determines whether this reference is the current reference or not
    var active: Bool { get }
    
    /// A parent id of a reference if a reference has parent
    var parentId: String? { get }
    
    /// A reference relative path in a repository
    var path: String { get }
    
    /// A reference name. Exists in a path
    var name: String { get }
    
    /// A creator of this reference
    var author: String { get }
    
    /// Creation date of a reference
    var date: Date { get }
    
    /// The complete message in a commit and tag object
    var message: String? { get }
}
