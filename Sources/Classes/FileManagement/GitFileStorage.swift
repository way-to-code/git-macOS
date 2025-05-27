//
//  GitFileStorage.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

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
        
        FileManager.writeFile(toPath: filePath, content: content)
    }
}

// MARK: - Private
extension GitFileStorage {
    func fullPath(of file: Accessible, relatedTo path: String) -> String {
        return URL(fileURLWithPath: path).appendingPathComponent(file.path).path
    }
}
