//
//  GitCherryResult.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
