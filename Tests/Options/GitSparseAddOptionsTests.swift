//
//  GitSparseAddOptionsTest.swift
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

final class GitSparseAddOptionsTest: XCTestCase {
    func test_toArguments_doesNotContainOptionsWhenNoFilePathsProvided() {
        var sut = makeSUT()
        
        sut.options.filePaths = []
        sut.assertOptions(equal: "")
    }
    
    func test_toArguments_containsSingleFileArgument() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["fileName1"]
        sut.assertOptions(equal: "add -- fileName1")
    }
    
    func test_toArguments_containsTwoFilesArgument() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["fileName1", "fileName2"]
        sut.assertOptions(equal: "add -- fileName1 fileName2")
    }
    
    func test_toArguments_escapesSpacesInFileNames() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["file name with spaces"]
        sut.assertOptions(equal: "add -- file name with spaces")
        
        sut.options.filePaths = ["level 1/level 2"]
        sut.assertOptions(equal: "add -- level 1/level 2")
    }
    
    func test_toArguments_handlesFileNamesWithDashes() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["level1/level2/level3"]
        sut.assertOptions(equal: "add -- level1/level2/level3")
    }
}

// MARK: - SUT
fileprivate extension GitSparseAddOptionsTest {
    struct SUT {
        var options: GitSparseAddOptions
        
        func toArguments() -> [String] {
            options.toArguments()
        }
    }
    
    func makeSUT() -> SUT {
        let options = GitSparseAddOptions(filePaths: [])
        
        return SUT(
            options: options)
    }
}

// MARK: - Asserts
fileprivate extension GitSparseAddOptionsTest.SUT {
    func assertOptions(
        equal expectedValue: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let resultedValue = toArguments().joined(separator: " ")
        
        XCTAssertEqual(
            resultedValue, expectedValue,
            "Unexpected arguments received",
            file: file, line: line)
    }
}
