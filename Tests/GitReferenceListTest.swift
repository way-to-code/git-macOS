//
//  GitReferenceListTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import XCTest
import Git

class GitReferenceListTest: XCTestCase {
    
    private func createReferences(with names: [String]) -> [RepositoryReference] {
        var json = "["
        for name in names {
            json += "{\"id\":\"\",\"active\":false,\"author\":\"\",\"date\":1529362190,\"path\":\"\(name)\"},"
        }
        
        json = json.trimmingCharacters(in: CharacterSet(charactersIn: ",")) + "]"
        
        let decoder = JSONDecoder()
        guard let refs = try? decoder.decode(Array<GitReference>.self, from: json.data(using: .utf8)!) else {
            XCTFail("Unable to decode json, please check the JSON")
            return []
        }
        
        return refs
    }

    func testBranchParsingLogic() {
        let names = ["refs/tags/1.0", "refs/tags/1.1",
                     "refs/remotes/origin/stable1", "refs/remotes/origin/stable2", "refs/remotes/origin/stable3",
                     "refs/heads/local"]
        
        let refs = createReferences(with: names)
        
        // create a list
        let list = GitReferenceList(refs)
        
        // integrity
        XCTAssert(list.references.count == 6)
        
        // remotes
        XCTAssert(list.remoteBranches.count == 3)
        
        // tags
        XCTAssert(list.tags.count == 2)
        
        // local branches
        XCTAssert(list.localBranches.count == 1)
    }
    
    struct RefNameTestCase {
        
        var path: String
        
        var fullName: String
        var lastName: String
        var localName: String
        var shortName: String
        var remoteName: String
    }
    
    func testReferenceName() {
        let testCases: [RefNameTestCase] = [
            .init(path: "refs",
                  fullName: "",
                  lastName: "",
                  localName: "",
                  shortName: "",
                  remoteName: ""),
            
            .init(path: "refs/",
                  fullName: "",
                  lastName: "",
                  localName: "",
                  shortName: "",
                  remoteName: ""),
            
            .init(path: "/refs",
                  fullName: "",
                  lastName: "",
                  localName: "",
                  shortName: "",
                  remoteName: ""),
            
            .init(path: "master",
                  fullName: "master",
                  lastName: "master",
                  localName: "master",
                  shortName: "master",
                  remoteName: ""),
            
            .init(path: "refs/remotes",
                  fullName: "remotes",
                  lastName: "remotes",
                  localName: "remotes",
                  shortName: "remotes",
                  remoteName: ""),
            
            .init(path: "/refs/remotes/",
                  fullName: "remotes",
                  lastName: "remotes",
                  localName: "remotes",
                  shortName: "remotes",
                  remoteName: ""),
            
            .init(path: "refs/heads/master",
                  fullName: "heads/master",
                  lastName: "master",
                  localName: "master",
                  shortName: "master",
                  remoteName: ""),
            
            .init(path: "refs/heads/feature/name",
                  fullName: "heads/feature/name",
                  lastName: "name",
                  localName: "feature/name",
                  shortName: "feature/name",
                  remoteName: ""),
            
            .init(path: "refs/remotes/origin",
                  fullName: "remotes/origin",
                  lastName: "origin",
                  localName: "origin",
                  shortName: "origin",
                  remoteName: "origin"),
            
            .init(path: "refs/remotes/origin/branch_name",
                  fullName: "remotes/origin/branch_name",
                  lastName: "branch_name",
                  localName: "branch_name",
                  shortName: "origin/branch_name",
                  remoteName: "origin"),
            
            .init(path: "refs/remotes/origin/branch_name/",
                  fullName: "remotes/origin/branch_name",
                  lastName: "branch_name",
                  localName: "branch_name",
                  shortName: "origin/branch_name",
                  remoteName: "origin"),
            
            .init(path: "refs/remotes/origin/feature/branch_name",
                  fullName: "remotes/origin/feature/branch_name",
                  lastName: "branch_name",
                  localName: "feature/branch_name",
                  shortName: "origin/feature/branch_name",
                  remoteName: "origin"),
        ]
        
        for testCase in testCases {
            guard let ref = createReferences(with: [testCase.path]).first else {
                XCTFail("Unable to create a reference. Case: \(testCase.path)")
                return
            }
            
            XCTAssert(ref.name.fullName == testCase.fullName, "case: \(testCase.path)")
            XCTAssert(ref.name.lastName == testCase.lastName, "case: \(testCase.path)")
            XCTAssert(ref.name.shortName == testCase.shortName, "case: \(testCase.path)")
            XCTAssert(ref.name.localName == testCase.localName, "case: \(testCase.path)")
            XCTAssert(ref.name.remoteName == testCase.remoteName, "case: \(testCase.path)")
        }
    }
    
    func testReferenceNameCompare() {
        var left: GitReferenceName
        var right: GitReferenceName
        
        left = GitReferenceName(path: "refs")
        right = GitReferenceName(path: "refs")
        XCTAssert(left == right)
        
        left = GitReferenceName(path: "refs")
        right = GitReferenceName(path: "")
        XCTAssert(left == right)
        
        left = GitReferenceName(path: "refs/heads/feature/name")
        right = GitReferenceName(path: "refs/heads/feature/name")
        XCTAssert(left == right)
        
        left = GitReferenceName(path: "refs/remotes/origin")
        right = GitReferenceName(path: "refs/remotes/custom")
        XCTAssert(left != right)
    }
}
