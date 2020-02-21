//
//  GitMergeOptions.swift
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

/// A set of options used by the git clone operation
public class GitMergeOptions: ArgumentConvertible {
    
    // MARK: - Init
    public required init(reference: Reference) {
        self.reference = reference
    }
    
    /// Reference to be used to merge the active branch with
    public var reference: Reference
    
    /// Determinies whether to make auto merge commit or not.
    /// This equals to git merge `--no-commit` and  `--commit` options.
    ///
    /// Default value for this property is false, meaning no auto commit is made
    /// Setting this value to true, resets `squashCommits` to false
    public var shouldCommit: Bool = false {
        didSet {
            if shouldCommit {
                squashCommits = false
            }
        }
    }
    
    /// If set to true, all incoming commints will be combined as ones.
    ///
    /// Can be used only with `shouldCommit = false`.
    /// Setting this value to true automatically resets `shouldCommit` value to false.
    ///
    /// When a value of this property is false, `fastForward` is ignored
    public var squashCommits: Bool = false {
        didSet {
            if squashCommits {
                shouldCommit = false
            }
        }
    }
    
    /// Specifies how a merge is handled when the merged-in history is already a descendant of the current history
    /// Default option is `fastForwardWhenPossible`
    public var fastForward: FastForwardOptions = .fastForwardWhenPossible
    
    /// Aborts the current merge if any. When specified, all other keys are ignored
    internal var abort: Bool = false
        
    // MARK: - ArgumentConvertible
    func toArguments() -> [String] {
        guard !abort else {
            return ["--abort"]
        }
        
        var options: [String] = []
        
        /// 1. Reference to merge with
        options.append(reference.name)
        
        /// 2. Commit state
        if shouldCommit {
            options.append("--commit")
        } else {
            options.append("--no-commit")
        }
        
        // 3. Squash
        if squashCommits {
            options.append("--squash")
        } else {
            options.append("--no-squash")
        }
        
        // 4. Fast-forward. Only when squashCommits is not set
        if !squashCommits {
            options.append(contentsOf: fastForward.toArguments())
        }
        
        return options
    }
}

public extension GitMergeOptions {
    
    // MARK: - Reference
    class Reference {
        
        // MARK: - Init
        public init(name: String) {
            self.name = name
        }
        
        public private(set) var name: String
    }
    
    // MARK: - FastForwardOptions
    enum FastForwardOptions: ArgumentConvertible {
        
        /// When possible resolve the merge as a fast-forward. When fast-forward is not possible, create a merge commit (respecting shouldCommit option).
        /// This equals to git --ff option
        case fastForwardWhenPossible
        
        /// Create a merge commit in all cases, even when the merge could instead be resolved as a fast-forward.
        /// This equals to git --no-ff option
        case noFastForward
        
        /// Resolve the merge as a fast-forward when possible. When not possible, refuse to merge and exit with a non-zero status.
        /// This equals to git --ff-only
        case fastForwardOnly
        
        // MARK: - ArgumentConvertible
        func toArguments() -> [String] {
            switch self {
            case .fastForwardWhenPossible: return ["--ff"]
            case .noFastForward: return ["--no-ff"]
            case .fastForwardOnly: return ["--ff-only"]
            }
        }
    }
}
