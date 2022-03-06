//
//  TagTest.swift
//  GitTests
//
//  Created by Jeremy Greenwood on 1/14/22.
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
import Git

class TagTest: XCTestCase, RepositoryTest {
    private static let tag = "test-tag"
    private static let tag2 = "test-tag-2"
    private static let message = "This is a test tag"

    var repositoryBundleName: String { "" }

    private var repository: GitRepository!

    override func setUpWithError() throws {
        repository = try createEmptyRepositoryWithCommit()
    }

    override func tearDownWithError() throws {
        if let path = repository?.localPath {
            FileManager.removeDirectory(atPath: path)
        }
    }

    func testAnnotate() throws {
        try repository.tag(options: .annotate(tag: Self.tag, message: Self.message))
    }

    func testLightWeight() throws {
        try repository.tag(options: .lightWeight(tag: Self.tag))
    }

    func testLightWeightWithCommit() throws {
        let hash = try repository.listLogRecords().records.first!.hash
        try repository.tag(options: .lightWeight(tag: Self.tag, commitHash: hash))

        let tag = String.parseRef(try repository.listLogRecords().records.first!.refNames)["tag"]
        XCTAssert(tag == Self.tag, "Expected \(String(describing: tag)) and \(Self.tag) to be the same")
    }

    func testList() throws {
        try repository.tag(options: .lightWeight(tag: Self.tag))
        try repository.tag(options: .lightWeight(tag: Self.tag2))

        let tagList = try repository.tagList()
        XCTAssert(tagList.records.contains(where: { $0.tag == Self.tag }), "Expected tag list to contain \(Self.tag), but does not")
        XCTAssert(tagList.records.contains(where: { $0.tag == Self.tag2 }), "Expected tag list to contain \(Self.tag2), but does not")

        let tagListWithPattern = try repository.tagList(pattern: Self.tag)
        XCTAssert(tagListWithPattern.records.contains(where: { $0.tag == Self.tag }), "Expected tag list to contain \(Self.tag), but does not")
        XCTAssertFalse(tagListWithPattern.records.contains(where: { $0.tag == Self.tag2 }), "Tag list unexpectedly contains \(Self.tag2)")
    }

    func testDeleteTagNotFound() throws {
        XCTAssertThrowsError(try repository.tag(options: .delete(tag: Self.tag)), "Expected to fail since tag is not first created") { error in
            guard let gitError = error as? GitError else {
                XCTFail("Unexpected Error type.")
                return
            }

            switch gitError {
            case .tagError(let message):
                XCTAssert(message.contains("not found"), "Unexpected error message")
                break
            default:
                XCTFail("Unexpected Error case.")
            }
        }
    }

    func testDelete() throws {
        try repository.tag(options: .lightWeight(tag: Self.tag))
        try repository.tag(options: .delete(tag: Self.tag))
    }
}

private extension String {
    static func parseRef(_ ref: String) -> Dictionary<String, String> {
        ref.replacingOccurrences(of: " ", with: "")
            .components(separatedBy: ",")
            .filter( { $0.contains(":") } )
            .map { $0.components(separatedBy: ":") }
            .filter { $0.count == 2 }
            .map { pair in Dictionary(uniqueKeysWithValues: [(pair[0], pair[1])]) }
            .reduce([:]) {
                var combined = $0

                for (k, v) in $1 {
                    combined[k] = v
                }

                return combined
            }
    }
}
