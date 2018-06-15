//
//  FileCoder.swift
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

/// A declaration of a content processor
@dynamicMemberLookup open class FileCoder {
    
    // MARK: - Public
    
    /// Initializes a coder with the specified file
    ///
    /// - Parameter file: A file that will be used by a coder
    public required init(file: Accessible) {
        self.file = file
    }
    
    /// Returns an object from decoded content (if possible)
    public subscript<T>(dynamicMember key: String) -> T? {
        return value(for: key)
    }

    /// Encodes a state of a coder to a raw data. Default implementation does nothing.
    ///
    /// You must provide you own encoding logic in subclasses
    ///
    /// - Returns: A raw representation of a state of a coder
    /// - Throws: An exception in case encoder has been fallen with an error
    open func encode() throws -> Data {
        return content
    }
    
    /// Decodes a content to a user-friendly data structure. Default implementation does nothing.
    ///
    /// You must provide your own decoding logic in subclasses.
    ///
    /// - Throws: An exception in case decoder has been fallen with an error
    open func decode() throws {
    }
    
    /// Returns a value for the specified key.
    ///
    /// You may override this method and provide your own implementation
    open func value<T>(for key: String) -> T? {
        return nil
    }
    
    public var content: Data {
        return file.content
    }
    
    private(set) public weak var file: Accessible!
}
