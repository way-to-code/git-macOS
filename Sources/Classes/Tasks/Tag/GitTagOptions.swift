//
//  GitTagOptions.swift
//  Git-macOS
//
//  Copyright (c) Jeremy Greenwood
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

/// A set of options that are used for the tagging operation
public enum GitTagOptions: ArgumentConvertible {
    /// Makes an unsigned, annotated tag object with the given name and message.
    /// Optionally, you can specify the exact commit hash from that a tag should be created.
    /// If no commit hash is provided, a tag will be created from HEAD by the default.
    case annotate(tag: String, message: String, commitHash: String? = nil)
    
    /// Deletes the existing tag with the given name
    case delete(tag: String)
    
    /// Creates a lightweight tag that points directly at the given commit hash (if provided).
    case lightWeight(tag: String, commitHash: String? = nil)
    
    func toArguments() -> [String] {
        switch self {
        case let .annotate(tag, message, commit):
            return ["-a", tag, "-m", message, commit].compactMap { $0 }

        case .delete(let tag):
            return ["-d", tag]

        case let .lightWeight(tag, commit):
            return [tag, commit].compactMap { $0 }
        }
    }
}
