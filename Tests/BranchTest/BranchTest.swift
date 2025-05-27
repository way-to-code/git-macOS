//
//  BranchTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import XCTest
import Git

class BranchTest: XCTestCase, RepositoryTest {
    
    var repositoryBundleName: String {
        return ""
    }
    
    private var repository: GitRepository!
    
    override func setUpWithError() throws {
        repository = try createEmptyRepositoryWithCommit()
    }
    
    override func tearDownWithError() throws {
        if let path = repository?.localPath {
            FileManager.removeDirectory(atPath: path)
        }
    }
    
    func testBranch() {
        do {
            // Get the list of references before
            let referencesBefore = try repository.listReferences()
            
            // Create a new local branch
            let reference = try repository.createBranch(branchName: "branchTest", options: .default)
            
            // Get the list of references after
            let referencesAfter = try repository.listReferences()
            
            XCTAssert(referencesBefore.localBranches.count != referencesAfter.localBranches.count)
            XCTAssert(referencesAfter.localBranches.contains(where: {$0.name.localName == "branchTest"}))
            
            // #2. Check starting point
            let options = GitBranchOptions()
            options.fromReferenceName = "referenceDoesNotExist"
            
            do {
                // Create a branch from a reference that does not exist
                try repository.createBranch(branchName: "canNotCreate", options: options)
                XCTFail("This case should never happen. Can not create a branch from non existing reference")
            } catch {
            }
            
            // Create a branch from a reference that does exist
            options.fromReferenceName = "branchTest"
            try repository.createBranch(branchName: "canCreate", options: options)
            
            // #3. Branch already exists
            do {
                try repository.createBranch(branchName: "branchTest", options: .default)
                XCTFail("This case should never happen. Can not create a branch with the same name")
            } catch {
            }
            
            // Get the current branch name
            var references = try repository.listReferences()
            if let activeReference = references.currentReference {
                XCTAssert(activeReference.name.localName != "branchTest")
            }
            
            // #4. Checkout to a new branch
            try repository.checkout(reference: reference)
            
            // Ensure that the new branch is the active one
            references = try repository.listReferences()
            if let activeReference = references.currentReference {
                XCTAssert(activeReference.name.localName == "branchTest")
            }
        } catch {
            XCTFail("Unable to test branch due to the following error: \(error)")
        }
    }
}
