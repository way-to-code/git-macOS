//
//  FileStorage.swift
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

public enum FileStorageError: Error {
    
    /// Occurs when a file storage can not read a content of a file at the specified path
    case unableToReadFile(atPath: String)
    
    /// Occurs when a file storage can not write a content of a file at the specified path
    case unableToWriteFile(atPath: String)
}

public protocol Accessible: class {
    
    /// A path of an accessible object
    var path: String { get }
    
    /// A content of an accessible object
    var content: Data { get }
    
    /// An options of an accessible object
    var options: FileOptions { get }
    
    /// A list of annotations of an accessible object
    var annotations: [FileAnnotationRecord] { get }
}

/// A file storage provides a basic operation to work with files (like reading & saving)
public protocol FileStorage: class {
    
    /// Reads a content of an object
    func read(contentOf file: Accessible) throws -> Data
    
    /// Reads a line by line history of a file.
    /// If a storage does not support loading of annotations, the method returns an empty list
    func read<T: FileAnnotationRecord>(annotationsOf file: Accessible) -> [T]
    
    /// Writes a data back to a file
    func write(file: Accessible) throws
}
