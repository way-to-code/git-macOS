//
//  GitSparseAddOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public struct GitSparseAddOptions: ArgumentConvertible {
    /// Relative folder paths to be added to the sparse checkout.
    /// E.q. some/folder
    public var filePaths: [String]
    
    public init(filePaths: [String]) {
        self.filePaths = filePaths
    }
    
    func toArguments() -> [String] {
        guard !filePaths.isEmpty else { return [] }
        
        var arguments = ["add", "--"]
        
        for path in filePaths {
            arguments.append(path)
        }
        
        return arguments
    }
}
