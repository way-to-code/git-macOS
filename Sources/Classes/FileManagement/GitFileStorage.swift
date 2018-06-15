//
//  GitFileStorage.swift
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

/// A default file storage for a git repository
public class GitFileStorage: FileStorage {

    /// A repository object related to this storage
    private var repository: GitRepository

    public init(repository: GitRepository) {
        self.repository = repository
    }
    
    public func read(contentOf file: Accessible) throws -> Data {
        guard let repoPath = repository.localPath else {
            throw RepositoryError.repositoryNotInitialized
        }
        
        let filePath = fullPath(of: file, relatedTo: repoPath)
        
        guard let content = try String(contentsOfFile: filePath).data(using: .utf8) else {
            throw FileStorageError.unableToReadFile(atPath: filePath)
        }
        
        return content
    }
    
    public func read<T: FileAnnotationRecord>(annotationsOf file: Accessible) -> [T] {
        return []
    }

    public func write(file: Accessible) throws {
        guard let repoPath = repository.localPath else {
            throw RepositoryError.repositoryNotInitialized
        }
        
        let filePath = fullPath(of: file, relatedTo: repoPath)
        
        guard let content = String(data: file.content, encoding: .utf8) else {
            throw FileStorageError.unableToWriteFile(atPath: filePath)
        }
        
        FileManager.writeFile(to: filePath, content: content)
    }
}

// MARK: - Private
extension GitFileStorage {
    func fullPath(of file: Accessible, relatedTo path: String) -> String {
        return URL(fileURLWithPath: path).appendingPathComponent(file.path).path
    }
}
