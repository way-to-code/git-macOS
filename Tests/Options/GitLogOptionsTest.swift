//
//  GitLogOptionsTest.swift
//  Git-macOS
//
//  Copyright (c) Created by Max Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 
//

import Foundation
import Git
import XCTest

final class GitLogOptionsTest: XCTestCase {
    func test_toArguments_properlyConvertsLimitOptions() {
        let sut = makeSUT()
        
        sut.options.limit = .none
        sut.assertArguments(equalTo: "")
        
        sut.options.limit = 0
        sut.assertArguments(equalTo: "-0")
        
        sut.options.limit = 99
        sut.assertArguments(equalTo: "-99")
    }
    
    func test_toArguments_properlyConvertsAuthorOptions() {
        let sut = makeSUT()
        
        sut.options.author = .none
        sut.assertArguments(equalTo: "")
        
        sut.options.author = "some-test-author"
        sut.assertArguments(equalTo: "--author=\"some-test-author\"")
    }
    
    func test_toArguments_properlyConvertsAfterOptions() {
        let sut = makeSUT()
        
        sut.options.after = .none
        sut.assertArguments(equalTo: "")
        
        sut.options.after = Date(timeIntervalSince1970: 0.0)
        sut.assertArguments(equalTo: "--after=\"1970-01-01T00:00:00\"")
    }
    
    func test_toArguments_properlyConvertsBeforeOptions() {
        let sut = makeSUT()
        
        sut.options.before = .none
        sut.assertArguments(equalTo: "")
        
        sut.options.before = Date(timeIntervalSince1970: 0.0)
        sut.assertArguments(equalTo: "--before=\"1970-01-01T00:00:00\"")
    }
    
    func test_toArguments_properlyConvertsReferenceOptions() {
        let sut = makeSUT()
        
        sut.options.reference = .none
        sut.assertArguments(equalTo: "")
        
        sut.options.reference = GitLogOptions.Reference(
            name: "some-test-reference")
        sut.assertArguments(equalTo: "")
        
        sut.options.reference = GitLogOptions.Reference(
            name: "some-test-reference",
            remote: RepositoryRemoteStub.make("remote-name"))
        sut.assertArguments(equalTo: "remote-name/some-test-reference")
    }
    
    func test_toArguments_properlyConvertsNoMergesOptions() {
        let sut = makeSUT()
        
        sut.options.noMerges = false
        sut.assertArguments(equalTo: "")
        
        sut.options.noMerges = true
        sut.assertArguments(equalTo: "--no-merges")
    }
}

// MARK: - SUT
fileprivate extension GitLogOptionsTest {
    struct SUT: ArgumentConvertible {
        var options: GitLogOptions
        
        func toArguments() -> [String] {
            options.toArguments()
        }
    }
    
    func makeSUT() -> SUT {
        let options = GitLogOptions()
        
        return SUT(
            options: options)
    }
}

// MARK: - RepositoryRemoteStub
fileprivate struct RepositoryRemoteStub: RepositoryRemote {
    static func make(_ name: String) -> Self {
        RepositoryRemoteStub(name: name, url: URL(string: "any-url-path")!)
    }
    
    var name: String
    var url: URL
    
    mutating func rename(to name: String) throws {}
    mutating func changeURL(to newUrl: URL) throws {}
}
