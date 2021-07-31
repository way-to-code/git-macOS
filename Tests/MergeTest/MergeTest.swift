//
//  MergeTest.swift
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

import XCTest
@testable import Git

class MergeTest: XCTestCase, RepositoryTest {
    
    var repositoryBundleName: String {
        return "MergeRepository.bundle"
    }
    
    private var repository: GitRepository!
    
    func testMergeWithoutChanges() {
        do {
            repository = createRepository()!
            try? repository.mergeAbort()
            
            try repository.checkout(reference: try reference(named: "feature/no-changes", in: repository))
            
            var numberOfCommitsBeforeMerge = try repository.listLogRecords().records.count
            XCTAssert(numberOfCommitsBeforeMerge == 1)
            
            let options = GitMergeOptions(reference: .init(name: "master"))
            options.shouldCommit = false
            options.squashCommits = false
            
            try repository.merge(options: options)
            
            numberOfCommitsBeforeMerge = try repository.listLogRecords().records.count
            XCTAssert(numberOfCommitsBeforeMerge == 3)
        } catch {
            XCTFail("Unable to test merge due to the following error: \(error)")
        }
    }
    
    func testMergeWithChanges() {
        do {
            repository = createRepository()!
            try? repository.mergeAbort()
            
            try repository.checkout(reference: try reference(named: "feature/has-changes", in: repository))
            
            let options = GitMergeOptions(reference: .init(name: "master"))
            options.shouldCommit = false
            options.squashCommits = false
            
            repository.delegate = self
            try repository.merge(options: options)
        } catch RepositoryError.mergeFinishedWithConflicts {
            // Pass throw. Consider the merge is finished
        } catch {
            XCTFail("Unable to test merge due to the following error: \(error)")
        }
    }
    
    private func reference(named: String, in repository: GitRepository) throws -> RepositoryReference {
        return try repository.listReferences().references.first(where: {$0.name.localName == named})!
    }
}

// MARK: - RepositoryDelegate
extension MergeTest: RepositoryDelegate {
    
    func repository(_ repository: Repository, didFinishMerge output: String?) {
    }
}
