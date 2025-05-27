//
//  MergeTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import XCTest
import Git

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
