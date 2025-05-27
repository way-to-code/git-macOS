//
//  GitFileStatusList.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

/// Describes a status of a single status operation
public class GitFileStatusList {

    // MARK: - Public
    public required init(files: [GitFileStatus] = []) {
        self.files = files
    }
    
    /// Adds a new status the list if not exists
    ///
    /// If the given status already exists in the list, the exception is raised.
    /// - Parameter status: A file status to add to the list
    public func add(_ status: GitFileStatus) throws {
        guard !contains(filePath: status.path) else {
            throw Exception.fileStatusAlreadyExists
        }
        
        files.append(status)
    }
    
    /// Removes all statuses from the list those file paths are the same as the given status has
    /// - Parameter status: A file status that path will be used to search all statuses to remove
    public func remove(_ status: GitFileStatus) {
        files.removeAll(where: {$0.path == status.path})
    }
    
    /// Searches for the given status in the list and replaces it with the new one.
    ///
    /// The comparison is made using the  file path of the given status. Be ware. all statuses with the same file path will be replaced
    /// - Parameter status: A file status to replace the existing one with
    public func replace(_ status: GitFileStatus) {
        for (index, file) in files.enumerated() {
            if file.path == status.path {
                files[index] = status
            }
        }
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


