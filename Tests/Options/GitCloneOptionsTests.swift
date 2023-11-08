//
//  GitCloneOptionsTest.swift
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

import Foundation
import Git
import XCTest

final class GitCloneOptionsTest: XCTestCase {
    func test_toArguments_properlyConvertsCheckoutOptions() {
        let sut = makeSUT()
        
        sut.options.checkout = .checkout
        sut.assertOptions(doNotContain: "checkout")
        
        sut.options.checkout = .noCheckout
        sut.assertOptions(contain: "--no-checkout")
    }
    
    func test_toArguments_properlyConvertsDepthOptions() {
        let sut = makeSUT()
        
        sut.options.depth = .head
        sut.assertOptions(contain: "--depth 1")
        
        sut.options.depth = .limited(numberOfRevisions: 1)
        sut.assertOptions(contain: "--depth 1")
        
        sut.options.depth = .limited(numberOfRevisions: 12)
        sut.assertOptions(contain: "--depth 12")
        
        sut.options.depth = .limited(numberOfRevisions: 123)
        sut.assertOptions(contain: "--depth 123")
        
        sut.options.depth = .limited(numberOfRevisions: 0)
        sut.assertOptions(doNotContain: "depth")
        
        sut.options.depth = .unlimited
        sut.assertOptions(doNotContain: "depth")
    }
    
    func test_toArguments_properlyConvertsBranchOptions() {
        let sut = makeSUT()
        
        sut.options.branches = .head
        sut.assertOptions(contain: "--single-branch")
        sut.assertOptions(doNotContain: "--branch")
        
        sut.options.branches = .all
        sut.assertOptions(contain: "--no-single-branch")
        sut.assertOptions(doNotContain: "--branch")

        sut.options.branches = .single(named: "specificBranchName")
        sut.assertOptions(contain: "--single-branch")
        sut.assertOptions(contain: "--branch specificBranchName")
    }
    
    func test_toArguments_properlyConvertsTagsOptions() {
        let sut = makeSUT()
        
        sut.options.tags = .fetch
        sut.assertOptions(doNotContain: "tags")
        
        sut.options.tags = .noTags
        sut.assertOptions(contain: "--no-tags")
    }
    
    func test_toArguments_properlyConvertsSparseOptions() {
        let sut = makeSUT()
        
        sut.options.sparse = .sparse
        sut.assertOptions(contain: "--sparse")
        
        sut.options.sparse = .noSparse
        sut.assertOptions(doNotContain: "sparse")
    }
    
    func test_toArguments_properlyConvertsQuietOptions() {
        let sut = makeSUT()
        
        sut.options.quiet = true
        sut.assertOptions(contain: "--quiet")
        
        sut.options.quiet = false
        sut.assertOptions(doNotContain: "--quiet")
    }
    
    func test_toArguments_properlyConvertsProgressOptions() {
        let sut = makeSUT()
        
        sut.options.progress = true
        sut.assertOptions(contain: "--progress")
        
        sut.options.progress = false
        sut.assertOptions(doNotContain: "--progress")
    }
}

// MARK: - SUT
fileprivate extension GitCloneOptionsTest {
    struct SUT {
        var options: GitCloneOptions
        
        func toArguments() -> [String] {
            options.toArguments()
        }
    }
    
    func makeSUT() -> SUT {
        let options = GitCloneOptions()
        
        return SUT(
            options: options)
    }
}

// MARK: - Asserts
fileprivate extension GitCloneOptionsTest.SUT {
    func assertOptions(
        contain expectedValue: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let resultedValue = toArguments().joined(separator: " ")
        
        if !resultedValue.contains(expectedValue) {
            XCTFail(
                "The resulted options expected to contain `\(expectedValue)`. Received `\(resultedValue)`",
                file: file, line: line)
        }
    }
    
    func assertOptions(
        doNotContain expectedValue: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let resultedValue = toArguments().joined(separator: " ")
        
        if resultedValue.contains(expectedValue) {
            XCTFail(
                "The resulted options expected NOT to contain `\(expectedValue)`. Received `\(resultedValue)`",
                file: file, line: line)
        }
    }
}
