//
//  GitStatusOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

/// A set of options used by the git status operation
public class GitStatusOptions: ArgumentConvertible {
    
    /// Returns a default options
    public static var `default` = GitStatusOptions()

    public init() {}

    /// The list of file names to be added
    internal var files: [String] = []
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments: [String] = []
        
        arguments.append("--porcelain")
        
        // Add file names
        for fileName in files {
            arguments.append(fileName)
        }
        
        return arguments
    }
}

// MARK: - Internal
internal extension GitStatusOptions {
    
    func addFiles(_ files: [String]) {
        self.files = files
    }
}
