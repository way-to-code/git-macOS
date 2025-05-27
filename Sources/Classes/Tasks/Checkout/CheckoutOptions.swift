//
//  CheckoutOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options used by the git checkout operation
public class GitCheckoutOptions: ArgumentConvertible {

    // MARK: - Public
    public init() {
    }
    
    public init(files: [String]) {
        self.files = files
        self.checkoutAllFiles = false
    }
    
    /// The list of file names to checkout.
    ///
    /// Is ignored when checkoutAllFiles is set
    public var files: [String] = []
    
    /// When set to true, checks out all files in the worktree.
    ///
    /// This is equivalent to git checkout . When set to true, files propery is ignored in that case
    public var checkoutAllFiles: Bool = true
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments: [String] = []
        
        if checkoutAllFiles {
            arguments.append(".")
        } else if files.count > 0 {
            // Do not interpret any more arguments as options.
            arguments.append("--")
            
            // Add file names
            for file in files {
                arguments.append(file)
            }
        }
        
        return arguments
    }
}
    
