//
//  GitLogCompareOptions.swift
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


/// A set of options used by the log comparison operations
public class GitLogCompareOptions {
    
    /// Returns the default options for the log comparison operation
    public static var `default`: GitLogCompareOptions {
        return GitLogCompareOptions()
    }
        
    // MARK: - Init
    fileprivate init() {
        lhsReference = nil
        rhsReference = nil
    }
    
    init(lhsReference: Reference, rhsReference: Reference) {
        self.lhsReference = lhsReference
        self.rhsReference = rhsReference
    }
    
    /// Reference to be used as the left hand side of the comparison. When a value is not specified, the active local reference will be used for comparison
    public var lhsReference: Reference?
    
    /// Reference to be used as the right hand size of the comparison. When a value is not specified, the active reference remote will be used for comparison
    public var rhsReference: Reference?
    
    /// Defines a repository fetch strategy when at least one reference participating in the comparison is a remote one.
    ///
    /// Default value for this property means that when at least one reference is a remote one, repository will be fetched before the comparison is made.
    /// When both references participating in the comparison are local, the value of this property is ignored, meaning no fetch will be done at all.
    public var fetchStrategy: FetchStrategy = .fetchRemotesBeforeComparison
}

// MARK: - GitLogCompareOptions
public extension GitLogCompareOptions {
    
    /// Describes a direction of the log comparison
    enum ComparisonDirection {
        
        /// Local direction means that a local reference will be uses for the comparison
        case local
        
        /// Remote direction means that a reference from a remote will be uses for the comparison
        case remote(remote: RepositoryRemote)
    }
    
    /// Describes the repository fetch strategy before the comparison is make
    enum FetchStrategy {
        
        /// When at least one reference is a remote one, perform repository fetch. When both references participated in comparison are local, this is ignored
        case fetchRemotesBeforeComparison
        
        /// Do not perform the fetch operation before the comparison, even at least one reference participating in the comparison is a remote one
        case ignore
    }
    
    /// Describes a reference used for the log comparison
    class Reference {
        
        required init(referenceName: String, direction: ComparisonDirection) {
            self.name = referenceName
            self.direction = direction
        }
        
        /// A reference name
        public private(set) var name: String
        
        /// A comparison direction
        ///
        /// Specify `local` direction when a local reference needs to be checked, otherwise `remote` should be specified
        public private(set) var direction: ComparisonDirection
    }
}

public extension GitLogCompareOptions {
    
    /// Creates options for retrieving locally committed but not pushed to a remote log records
    static func pending(for repository: GitRepository, in remote: RepositoryRemote) throws -> GitLogCompareOptions {
        guard let reference = try repository.listReferences().currentReference else {
            throw Exception.unableToRetrieveCurrentReference
        }
        
        return GitLogCompareOptions(lhsReference: .init(referenceName: reference.name, direction: .local),
                                    rhsReference: .init(referenceName: reference.name, direction: .remote(remote: remote)))
    }
    
    /// Creates options for retrieving commited to remotes but not presented in the current branch log records
    static func incoming(for repository: GitRepository, in remote: RepositoryRemote) throws -> GitLogCompareOptions {
        guard let reference = try repository.listReferences().currentReference else {
            throw Exception.unableToRetrieveCurrentReference
        }
        
        return GitLogCompareOptions(lhsReference: .init(referenceName: reference.name, direction: .remote(remote: remote)),
                                    rhsReference: .init(referenceName: reference.name, direction: .local))
    }
}

// MARK: - Internal
internal extension GitLogCompareOptions.ComparisonDirection {
    
    var isLocal: Bool {
        switch self {
        case .remote: return false
        case .local: return true
        }
    }
    
    var remote: RepositoryRemote? {
        switch self {
        case .remote(let remote): return remote
        default: return nil
        }
    }
}

internal extension GitLogCompareOptions {
    
    enum Exception: Error {
        case unableToRetrieveCurrentReference
    }
}
