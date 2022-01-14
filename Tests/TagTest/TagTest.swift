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
@testable import Git

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
        try repository.tag(options: .annotate(Self.tag, Self.message))
    }

    func testLightWeight() throws {
        try repository.tag(options: .lightWeight(Self.tag))
    }

    func testList() throws {
        try repository.tag(options: .lightWeight(Self.tag))
        try repository.tag(options: .lightWeight(Self.tag2))

        let tagList = try repository.tagList()
        XCTAssert(tagList.records.contains(where: { $0.tag == Self.tag }), "Expected tag list to contain \(Self.tag), but does not")
        XCTAssert(tagList.records.contains(where: { $0.tag == Self.tag2 }), "Expected tag list to contain \(Self.tag2), but does not")

        let tagListWithPattern = try repository.tagList(pattern: Self.tag)
        XCTAssert(tagListWithPattern.records.contains(where: { $0.tag == Self.tag }), "Expected tag list to contain \(Self.tag), but does not")
        XCTAssertFalse(tagListWithPattern.records.contains(where: { $0.tag == Self.tag2 }), "Tag list unexpectedly contains \(Self.tag2)")
    }

    func testDeleteTagNotFound() throws {
        try repository.tag(options: .delete(Self.tag))
        XCTExpectFailure("Expected to fail since tag is not first created")
    }

    func testDelete() throws {
        try repository.tag(options: .lightWeight(Self.tag))
        try repository.tag(options: .delete(Self.tag))
    }
}