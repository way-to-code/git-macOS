//
//  FileStorage.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public enum FileStorageError: Error {
    
    /// Occurs when a file storage can not read a content of a file at the specified path
    case unableToReadFile(atPath: String)
    
    /// Occurs when a file storage can not write a content of a file at the specified path
    case unableToWriteFile(atPath: String)
}

public protocol Accessible: AnyObject {
    
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
public protocol FileStorage: AnyObject {
    
    /// Reads a content of an object
    func read(contentOf file: Accessible) throws -> Data
    
    /// Reads a line by line history of a file.
    /// If a storage does not support loading of annotations, the method returns an empty list
    func read<T: FileAnnotationRecord>(annotationsOf file: Accessible) -> [T]
    
    /// Writes a data back to a file
    func write(file: Accessible) throws
}
