//
//  GitResetOptions.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

/// A set of options used by the git reset operation
public class GitResetOptions: ArgumentConvertible {
    
    public init() {
    }
    
    /// A mode to be used by git reset operation. If the mode is not specified, the operation will use the default option defined by git
    public var mode: Mode?
    
    /// A commit to be used for the reset operation. If the commit is not specified, the operation will use the default option defined by git
    public var commit: String?
    
    // The list of files to be used for a reset
    internal var files: [String] = []
    
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        var arguments: [String] = []

        if files.count > 0 {
            // Do not interpret any more arguments as options.
            arguments.append("--")
            
            // Add file names
            for file in files {
                arguments.append(file)
            }
            
            return arguments
        }
        
        if let mode = mode {
            switch mode {
            case .soft: arguments.append("--soft")
            case .mixed: arguments.append("--mixed")
            case .hard: arguments.append("--hard")
            case .merge: arguments.append("--merge")
            case .keep: arguments.append("--keep")
            }
        }
        
        if let commit = commit {
            arguments.append(commit)
        }
        
        return arguments
    }
}

public extension GitResetOptions {
    
    enum Mode {
        
        /// Does not touch the index file or the working tree at all
        case soft
        
        /// Resets the index but not the working tree
        case mixed
        
        /// Resets the index and working tree
        case hard
        
        /// Resets the index and updates the files in the working tree that are different between commit and HEAD,
        case merge
        
        /// Resets index entries and updates files in the working tree that are different between commit and HEAD
        case keep
    }
}
