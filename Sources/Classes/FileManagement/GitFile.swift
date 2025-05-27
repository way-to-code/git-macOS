//
//  GitFile.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

open class GitFile<T: FileCoder>: File<T> {
    
    /// Initilizes a git file with the specified options
    init?(relativePath path: String, in repository: GitRepository, options: FileOptions = .default) {
        super.init(relativePath: path, in: GitFileStorage(repository: repository), options: options)
    }
}

