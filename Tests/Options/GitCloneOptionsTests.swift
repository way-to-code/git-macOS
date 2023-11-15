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
        sut.assertArguments(doNotContain: "checkout")
        
        sut.options.checkout = .noCheckout
        sut.assertArguments(contain: "--no-checkout")
    }
    
    func test_toArguments_properlyConvertsDepthOptions() {
        let sut = makeSUT()
        
        sut.options.depth = .head
        sut.assertArguments(contain: "--depth 1")
        
        sut.options.depth = .limited(numberOfRevisions: 1)
        sut.assertArguments(contain: "--depth 1")
        
        sut.options.depth = .limited(numberOfRevisions: 12)
        sut.assertArguments(contain: "--depth 12")
        
        sut.options.depth = .limited(numberOfRevisions: 123)
        sut.assertArguments(contain: "--depth 123")
        
        sut.options.depth = .limited(numberOfRevisions: 0)
        sut.assertArguments(doNotContain: "depth")
        
        sut.options.depth = .unlimited
        sut.assertArguments(doNotContain: "depth")
    }
    
    func test_toArguments_properlyConvertsBranchOptions() {
        let sut = makeSUT()
        
        sut.options.branches = .head
        sut.assertArguments(contain: "--single-branch")
        sut.assertArguments(doNotContain: "--branch")
        
        sut.options.branches = .all
        sut.assertArguments(contain: "--no-single-branch")
        sut.assertArguments(doNotContain: "--branch")

        sut.options.branches = .single(named: "specificBranchName")
        sut.assertArguments(contain: "--single-branch")
        sut.assertArguments(contain: "--branch specificBranchName")
    }
    
    func test_toArguments_properlyConvertsTagsOptions() {
        let sut = makeSUT()
        
        sut.options.tags = .fetch
        sut.assertArguments(doNotContain: "tags")
        
        sut.options.tags = .noTags
        sut.assertArguments(contain: "--no-tags")
    }
    
    func test_toArguments_properlyConvertsSparseOptions() {
        let sut = makeSUT()
        
        sut.options.sparse = .sparse
        sut.assertArguments(contain: "--sparse")
        
        sut.options.sparse = .noSparse
        sut.assertArguments(doNotContain: "sparse")
    }
    
    func test_toArguments_properlyConvertsQuietOptions() {
        let sut = makeSUT()
        
        sut.options.quiet = true
        sut.assertArguments(contain: "--quiet")
        
        sut.options.quiet = false
        sut.assertArguments(doNotContain: "--quiet")
    }
    
    func test_toArguments_properlyConvertsProgressOptions() {
        let sut = makeSUT()
        
        sut.options.progress = true
        sut.assertArguments(contain: "--progress")
        
        sut.options.progress = false
        sut.assertArguments(doNotContain: "--progress")
    }
    
    func test_toArguments_properlyConvertsFilterOptions() {
        let sut = makeSUT()
        
        sut.options.filter = .noFilter
        sut.assertArguments(doNotContain: "filter")
        
        sut.options.filter = .omitAllBlobs
        sut.assertArguments(contain: "--filter=blob:none")
        
        sut.options.filter = .omitBlobsLargerThanSize(1024)
        sut.assertArguments(contain: "--filter=blob:limit=1024")
        
        sut.options.filter = .custom("combine:tree:3+blob:none")
        sut.assertArguments(contain: "--filter=combine:tree:3+blob:none")
    }
    
    func test_toArguments_escapesCustomFilterOptions() {
        let sut = makeSUT()
        
        sut.options.filter = .custom("~!@#$^&*()[]{}\\;\",<>?'` \n")
        sut.assertArguments(contain: "--filter=%7E%21%40%23%24%5E%26%2A%28%29%5B%5D%7B%7D%5C%3B%22%2C%3C%3E%3F%27%60%20%0A")
    }
}

// MARK: - SUT
fileprivate extension GitCloneOptionsTest {
    struct SUT: ArgumentConvertible {
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
