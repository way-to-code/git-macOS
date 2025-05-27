//
//  GitCherryResult.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

/// The result of execution of git cherry operation
public class GitCherryResult {

    // MARK: - Public
    required init(revisions: [GitCherryRevision]) {
        self.revisions = revisions
    }
    
    /// The list of all revisions
    public private(set) var revisions: [GitCherryRevision]
    
    /// Returns revisions filtered by the given type
    public func revisions(of revisionType: GitCherryRevision.RevisionType) -> [GitCherryRevision] {
        return revisions.filter({$0.type == revisionType})
    }
}

/// Describes a single revision of git cherry operation
public class GitCherryRevision {

    // MARK: - Public
    public required init(hash: String, type: RevisionType) {
        self.hash = hash
        self.type = type
    }
    
    public private(set) var hash: String
    
    public private(set) var type: RevisionType
    
    public enum RevisionType {
        case merged
        case unmerged
        
        internal init(sign: String) {
            if sign == "+" {
                self = .unmerged
            } else if sign == "-" {
                self = .merged
            } else {
                self = .unmerged
            }
        }
    }
}
