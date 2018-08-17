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

extension FileManager {
    
    /// Creates a directory on the local machine
    ///
    /// - parameter path: Path where a new directory should be created
    /// - parameter removeIfExists: If directory with the same path exists it will be removed before creation of a new directory
    static func createDirectory(at path: String, removeIfExists: Bool) throws {
        if removeIfExists {
            // check if directory at the provided path already exists and remove it if nessesary
            removeDirectory(at: path)
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
        
        try createDirectory(at: fullPath, removeIfExists: true)
        return fullPath
    }
    
    /// Removes the directory at the provided path
    static func removeDirectory(at path: String) {
        let fileManager = FileManager.default
        
        // check existence
        if fileManager.fileExists(atPath: path) {
            do { try fileManager.removeItem(atPath: path) } catch {
            }
        }
    }
    
    /// Writes a content to a file at the specified path
    static func writeFile(to path: String, content: String, overwrite: Bool = true) {
        do { try content.write(toFile: path, atomically: true, encoding: .utf8) }  catch _ as NSError {}
    }
}
