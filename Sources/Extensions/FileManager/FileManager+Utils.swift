//
//  GitCredentialsProvider.swift
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

enum FileStatusOnDisk {
    
    case exists(isDirectory: Bool)
    
    case notExists
}

extension FileStatusOnDisk: Equatable {
}

func ==(lhs: FileStatusOnDisk, rhs: FileStatusOnDisk) -> Bool {
    switch (lhs, rhs) {
    case (.exists(let isDirectoryLhs), .exists(let isDirectoryRhs)):
        return isDirectoryLhs == isDirectoryRhs

    case (.notExists, .notExists):
        return true

    default:
        return false
    }
}

extension FileManager {
    
    /// Creates a directory on the local machine
    ///
    /// - parameter path: Path where a new directory should be created
    /// - parameter removeIfExists: If directory with the same path exists it will be removed before creation of a new directory
    static func createDirectory(atPath path: String, removeIfExists: Bool) throws {
        if removeIfExists {
            // check if directory at the provided path already exists and remove it if nessesary
            removeDirectory(atPath: path)
        }
        
        try FileManager.default.createDirectory(atPath: path,
                                                withIntermediateDirectories: false,
                                                attributes: nil)
    }
    
    
    /// Creates a temporary directory on the local machine
    /// - returns: A path to the newly created directory
    static func createTemporaryDirectory() throws -> String {
        let directory = NSTemporaryDirectory()
        let fileName  = NSUUID().uuidString
        let fullPath  = directory + fileName
        
        try createDirectory(atPath: fullPath, removeIfExists: true)
        return fullPath
    }
    
    /// Removes the directory at the provided path
    static func removeDirectory(atPath path: String) {
        let fileManager = FileManager.default
        
        // check existence
        if fileManager.fileExists(atPath: path) {
            do { try fileManager.removeItem(atPath: path) } catch {
            }
        }
    }
    
    /// Checks a file status at the specified url
    static func checkFile(at url: URL) -> FileStatusOnDisk {
        var isDirectory = ObjCBool(true)
        let isFileExists = FileManager.default.fileExists(atPath: url.relativePath, isDirectory: &isDirectory)
        
        if isFileExists {
            return .exists(isDirectory: isDirectory.boolValue)
        } else {
            return .notExists
        }
    }
    
    /// Writes a content to a file at the specified path
    static func writeFile(toPath path: String, content: String, overwrite: Bool = true) {
        do { try content.write(toFile: path, atomically: true, encoding: .utf8) }  catch _ as NSError {}
    }
}
