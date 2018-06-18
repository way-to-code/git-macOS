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

    func testBranchParsingLogic() {
        let names = ["refs/tags/1.0", "refs/tags/1.1",
                     "refs/remotes/origin/stable1", "refs/remotes/origin/stable2", "refs/remotes/origin/stable3",
                     "refs/heads/local"]
        
        var json = "["
        
        for name in names {
            json += "{\"id\":\"\",\"active\":false,\"author\":\"\",\"date\":1529362190,\"path\":\"\(name)\"},"
        }
        
        json = json.trimmingCharacters(in: CharacterSet(charactersIn: ",")) + "]"
        
        let decoder = JSONDecoder()
        guard let refs = try? decoder.decode(Array<GitReference>.self, from: json.data(using: .utf8)!) else {
            XCTFail("Unable to decode json, please check the JSON")
            return
        }
        
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
}
