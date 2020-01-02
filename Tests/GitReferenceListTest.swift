//
//  GitReferenceListTest.swift
//  Git-macOS
//
//  Copyright (c) 2018 Max A. Akhmatov
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
    
    func testReferenceName() {
        let names = [
            // Remotes
            "\(GitReference.RefPath.remotes)/origin/branch_name",
            "\(GitReference.RefPath.remotes)/origin/branch_name/",
            "\(GitReference.RefPath.remotes)/origin/feature/branch_name",
            "\(GitReference.RefPath.remotes)/origin/feature/branch_name/",
            "\(GitReference.RefPath.remotes)/origin/path1/path2/branch_name",
            
            // Heads
            "\(GitReference.RefPath.heads)/branch_name",
            "\(GitReference.RefPath.heads)/branch_name/",
            "\(GitReference.RefPath.heads)/feature/branch_name",
            "\(GitReference.RefPath.heads)/feature/branch_name/",
            "\(GitReference.RefPath.heads)/path1/path2/branch_name",
            
            // Tags
            "\(GitReference.RefPath.tags)/branch_name",
            "\(GitReference.RefPath.tags)/branch_name/",
            "\(GitReference.RefPath.tags)/feature/branch_name",
            "\(GitReference.RefPath.tags)/feature/branch_name/",
            
            // Master
            "master",
        ]
        
        let refs = createReferences(with: names)
        
        XCTAssert(refs[0].name == "branch_name")
        XCTAssert(refs[0].shortName == "branch_name")
        XCTAssert(refs[1].name == "branch_name")
        XCTAssert(refs[1].shortName == "branch_name")
        XCTAssert(refs[2].name == "feature/branch_name")
        XCTAssert(refs[2].shortName == "branch_name")
        XCTAssert(refs[3].name == "feature/branch_name")
        XCTAssert(refs[3].shortName == "branch_name")
        XCTAssert(refs[4].name == "path1/path2/branch_name")
        XCTAssert(refs[4].shortName == "branch_name")
        
        XCTAssert(refs[5].name == "branch_name")
        XCTAssert(refs[5].shortName == "branch_name")
        XCTAssert(refs[6].name == "branch_name")
        XCTAssert(refs[6].shortName == "branch_name")
        XCTAssert(refs[7].name == "feature/branch_name")
        XCTAssert(refs[7].shortName == "branch_name")
        XCTAssert(refs[8].name == "feature/branch_name")
        XCTAssert(refs[8].shortName == "branch_name")
        XCTAssert(refs[9].name == "path1/path2/branch_name")
        XCTAssert(refs[9].shortName == "branch_name")
        
        XCTAssert(refs[10].name == "branch_name")
        XCTAssert(refs[10].shortName == "branch_name")
        XCTAssert(refs[11].name == "branch_name")
        XCTAssert(refs[11].shortName == "branch_name")
        XCTAssert(refs[12].name == "feature/branch_name")
        XCTAssert(refs[12].shortName == "branch_name")
        XCTAssert(refs[13].name == "feature/branch_name")
        XCTAssert(refs[13].shortName == "branch_name")
        
        XCTAssert(refs[refs.count - 1].name == "master")
        XCTAssert(refs[refs.count - 1].shortName == "master")
    }
}
