//
//  GitFileStatus.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

/// Describes a single file status
public class GitFileStatus {
    
    // MARK: - Init
    internal init(path: String, state: String) {
        self.path = path
        
        var lhs: String
        var rhs: String
        
        if state.count > 1 {
            lhs = String(state[state.startIndex])
            rhs = String(state[state.index(state.startIndex, offsetBy: 1)])
        } else {
            lhs = ModificationState.unknown.rawValue
            rhs = ModificationState.unknown.rawValue
        }
        
        self.state = State(lhs: lhs, rhs: rhs)
    }
    
    /// A path to the file on the disk including file name.
    /// File path is always relative to a repository root.
    public private(set) var path: String
    
    /// Current file state
    public private(set) var state: State
    
    /// Determines whether a status is a conflicted status or not
    public var hasConflicts: Bool {
        return state.conflict != nil
    }
    
    /// Indicates whether a file is staged for commit or not
    public var hasChangesInIndex: Bool {
        switch state.index {
        case .unmodified, .ignored, .untracked, .unknown:
            return false
        default:
            return true
        }
    }
    
    /// Indicates whether a file is changed in the worktree, but still not staged for commit
    public var hasChangesInWorktree: Bool {
        switch state.worktree {
        case .unmodified, .ignored, .untracked, .unknown:
            return false
        default:
            return true
        }
    }
}

// MARK: - Types
public extension GitFileStatus {
    
    // MARK: - State
    class State {
        
        // MARK: - Init
        public required init(index: ModificationState, worktree: ModificationState) {
            self.index = index
            self.worktree = worktree
        }
        
        internal convenience init(lhs: String, rhs: String) {
            let index = ModificationState(rawValue: lhs) ?? .unknown
            let worktree = ModificationState(rawValue: rhs) ?? .unknown

            self.init(index: index, worktree: worktree)
        }
        
        /// Shows the modification state of the index
        public var index: ModificationState
        
        /// Shows the modification status of the working tree
        public var worktree: ModificationState
        
        /// Shows the current merge conflict state. Returns nil when there is no conflict
        public var conflict: ConflictState? {
            switch (index, worktree) {
            // DD
            case (.deleted, .deleted): return .unmergedDeletedBoth
            
            // AU
            case (.added, .unmerged): return .unmergedAddedByUs
               
            // UD
            case (.unmerged, .deleted): return .unmergedDeletedByThem
                
            // UA
            case (.unmerged, .added): return .unmergedAddedByThem
                
            // DU
            case (.deleted, .unmerged): return .unmergedDeletedByUs
                
            // AA
            case (.added, .added): return .unmergedAddedBoth
                
            // UU
            case (.unmerged, .unmerged): return .unmergedModifiedBoth
                
            default: return nil
            }
        }
    }
    
    // MARK: - ModificationState
    enum ModificationState: String {
        
        case modified = "M"
        case added = "A"
        case deleted = "D"
        case renamed = "R"
        case copied = "C"
        case untracked = "?"
        case ignored = "!"
        case unmerged = "U"
        case unmodified = " "
        
        case unknown = "Z"
    }
    
    // MARK: - ConflictState
    enum ConflictState {
        
        case unmergedAddedBoth
        case unmergedAddedByUs
        case unmergedAddedByThem
        
        case unmergedDeletedBoth
        case unmergedDeletedByUs
        case unmergedDeletedByThem
        
        case unmergedModifiedBoth
    }
}
