//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

public extension GitRepository {
    
    func listLogRecords(options: GitLogOptions = GitLogOptions.default) throws -> GitLogRecordList {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        // Check whether a reference is provided
        if let reference = options.reference, reference.remote == nil {
            // Reference is provided, but it is required to take the first available remote
            let remotes = try listRemotes()
            
            if let remote = remotes.remotes.first {
                options.reference?.firstRemote = remote
            }
        }
        
        let task = LogTask(owner: self, options: options)
        try task.run()
        
        return task.records
    }
    
    func retrieveLogRecordsComparison(options: GitLogCompareOptions) throws -> GitLogRecordList {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        var shouldFetch = false
        
        let lhs = options.lhsReference
        let rhs = options.rhsReference
        
        var lhsReferenceName: String!
        var rhsReferenceName: String!
        
        if let lhs = lhs {
            if lhs.name == GitLogCompareOptions.Reference.mergeHead || lhs.name == GitLogCompareOptions.Reference.head {
                lhsReferenceName = lhs.name
            } else if let remote = lhs.direction.remote {
                shouldFetch = true
                lhsReferenceName = "\(remote.name)/\(lhs.name)"
            } else if lhs.direction.isLocal {
                lhsReferenceName = lhs.name
            }
        }
        
        if let rhs = rhs {
            if rhs.name == GitLogCompareOptions.Reference.mergeHead || rhs.name == GitLogCompareOptions.Reference.head {
                rhsReferenceName = rhs.name
            } else if let remote = rhs.direction.remote {
                shouldFetch = true
                rhsReferenceName = "\(remote.name)/\(rhs.name)"
            } else if rhs.direction.isLocal {
                rhsReferenceName = rhs.name
            }
        }
        
        if shouldFetch {
            switch options.fetchStrategy {
            case .fetchRemotesBeforeComparison(false):
                let fetchOptions = GitFetchOptions.default
                fetchOptions.force = false
                
                try fetchRemotes(options: fetchOptions)
                
            case .fetchRemotesBeforeComparison(true):
                let fetchOptions = GitFetchOptions.default
                fetchOptions.force = true
                
                try fetchRemotes(options: fetchOptions)
                
            default:
                break
            }
        }
        
        if lhsReferenceName == nil || rhsReferenceName == nil {
            guard let activeReference = try listReferences().currentReference else {
                // Fallback, as the current reference can not be obtained
                return GitLogRecordList()
            }
            
            if lhsReferenceName == nil {
                lhsReferenceName = activeReference.name.localName
            }
            
            if rhsReferenceName == nil, let remote = try listRemotes().remotes.first {
                rhsReferenceName = "\(remote.name)/\(activeReference.name)"
            }
        }
        
        guard lhsReferenceName != nil, rhsReferenceName != nil else {
            return GitLogRecordList()
        }
        
        let logOptions = GitLogOptions()
        logOptions.compareReference = .init(lhsReferenceName: lhsReferenceName, rhsReferenceName: rhsReferenceName)
        return try listLogRecords(options: logOptions)
    }
}
