//
//  GitFileStatusList.swift
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

/// Describes a status of a single status operation
public class GitFileStatusList {

    // MARK: - Public
    public required init(files: [GitFileStatus] = []) {
        self.files = files
    }
    
    public func add(_ status: GitFileStatus) throws {
        guard !contains(filePath: status.path) else {
            throw Exception.fileStatusAlreadyExists
        }
        
        files.append(status)
    }
    
    public func contains(filePath: String) -> Bool {
        return files.contains(where: {$0.path == filePath})
    }
    
    public private(set) var files: [GitFileStatus] = []
}

public extension GitFileStatusList {
    
    enum Exception: Error {
        case fileStatusAlreadyExists
    }
}

// MARK: - IndexSequence
extension GitFileStatusList: IndexSequence {

    subscript(index: Int) -> Any? {
        get {
            return files.count > index ? files[index] : nil
        }
    }
}

// MARK: - Sequence
extension GitFileStatusList: Sequence {
    
    var count: Int {
        return files.count
    }
    
    subscript(index: Int) -> GitFileStatus? {
        get {
            return files.count > index ? files[index] : nil
        }
    }
    
    public func makeIterator() -> IndexIterator<GitFileStatus> {
        return IndexIterator<GitFileStatus>(collection: self)
    }
}


