//
//  GitSparseSetOptions.swift
//  Git-macOS
//
//  Copyright (c) Created by Max Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 
//

import Foundation

public struct GitSparseSetOptions: ArgumentConvertible {
    /// Relative folder paths to be added to the sparse checkout.
    /// E.q. some/folder
    public var filePaths: [String]
    
    public init(filePaths: [String]) {
        self.filePaths = filePaths
    }
    
    /// When noCone is set, the input list is considered a list of patterns.
    /// This mode has a number of drawbacks, including not working with some options like --sparse-index
    public var noCone: Bool = false
    
    func toArguments() -> [String] {
        guard !filePaths.isEmpty else { return [] }
        
        var arguments = ["set"]
        
        if noCone {
            arguments.append("--no-cone")
        }
        
        arguments.append("--")
        
        for path in filePaths {
            arguments.append(path)
        }
        
        return arguments
    }
}
