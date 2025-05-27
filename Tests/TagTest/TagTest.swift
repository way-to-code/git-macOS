//
//  TagTest.swift
//  Git-macOS
//
//  Copyright (c) Jeremy Greenwood
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

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
        var record = try XCTUnwrap(try repository.listLogRecords().records.first)
        try repository.tag(options: .lightWeight(tag: Self.tag, commitHash: record.hash))

        record = try XCTUnwrap(try repository.listLogRecords().records.first)
        let tag = String.parseRef(record.refNames)["tag"]
        XCTAssert(tag == Self.tag, "Expected \(String(describing: tag)) and \(Self.tag) to be the same")
    }

    func testList() throws {
        try repository.tag(options: .lightWeight(tag: Self.tag))
        try repository.tag(options: .lightWeight(tag: Self.tag2))

        let tagList = try repository.listTags()
        XCTAssert(tagList.records.contains(where: { $0.tag == Self.tag }), "Expected tag list to contain \(Self.tag), but does not")
        XCTAssert(tagList.records.contains(where: { $0.tag == Self.tag2 }), "Expected tag list to contain \(Self.tag2), but does not")

        let tagListWithPattern = try repository.listTags(options: .pattern(Self.tag))
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
