//
//  File.swift
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

/// A file processing options
public struct FileOptions {
    
    /// Returns a default options to apply while processing a file
    public static var `default` = FileOptions()
    
    /// Indicates whether line annotations should be read.
    /// Setting this value to true may affect file reading performance, especially for big files
    public var annotations = false
}

/// A single file that can be readed/changed/saved
/// A file must have a valid content coder that can decode file's data to a handy high-level object
open class File<T: FileCoder>: Accessible {

    // MARK: - Init
    
    /// Initializes a file with a relative path in a storage
    ///
    /// After a file is initialized, it's content is readed and decoded by coder.
    /// In case file can not be loaded or encoded, the initilizer will fail
    ///
    /// - Parameters:
    ///   - path: A relative path to a file in a storage
    ///   - storage: A storage reponsible for read/write operations
    ///   - options: A file options
    public init(relativePath path: String, in storage: FileStorage, options: FileOptions = .default) {
        self.path = path
        self.storage = storage
        self.content = Data()
        self.options = options
        
        self.areUpdatesActive = false
        
        self.coder = T(file: self)
    }
    
    /// Reads a content of a file with a specified set of options.
    ///
    /// Use this method when you want to load and decode a file
    public func read(options: FileOptions = .default) throws {
        content = try storage.read(contentOf: self)

        if options.annotations {
            // load annotations
            annotations = storage.read(annotationsOf: self)
        }
        
        // decode the content
        try coder.decode()
    }
    
    /// Saves changes made in a coder to a file
    public func save() throws {
        guard !areUpdatesActive else { return }
        
        try content = coder.encode()
        try storage.write(file: self)
    }
    
    /// Begins an update on this file.
    ///
    /// While an update is active, all save calls on this file are ignored until endUpdates method is not called
    public func beginUpdates() {
        areUpdatesActive = true
    }
    
    /// Finishes updates on this file and saves all changes
    public func endUpdates() throws {
        guard areUpdatesActive else { return }
        areUpdatesActive = false
        
        try save()
    }
    
    // MARK: - Properties
    
    /// A list of line by line annotations
    private(set) public var annotations = [FileAnnotationRecord]()

    /// A content coder that works with a content
    private(set) public var coder: T!
    
    /// A file processing options of a file
    private(set) public var options: FileOptions
    
    /// A content of a file
    private(set) public var content: Data
    
    /// A path of a file in storage (relative path to the storage root)
    ///
    /// *Example*: if a storage has a local path */Users/demo* and a path is */files/example.txt*, the full path to a file on a disk will be */Users/demo/files/example.txt*
    private(set) public var path: String
    
    /// A file storage responsible for read/write operations
    private var storage: FileStorage
    
    /// Indicates whether an active saving transation has been started
    private var areUpdatesActive: Bool
}
