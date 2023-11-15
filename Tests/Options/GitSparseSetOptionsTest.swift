//
//  GitSparseSetOptionsTest.swift
//  GitTests
//
//  Created by Max Akhmatov (15.11.2023).
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
//

import Foundation
import Git
import XCTest

final class GitSparseSetOptionsTest: XCTestCase {
    func test_toArguments_doesNotContainOptionsWhenNoFilePathsProvided() {
        var sut = makeSUT()
        
        sut.options.filePaths = []
        sut.assertArguments(equalTo: "")
    }
    
    func test_toArguments_containsSingleFileArgument() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["fileName1"]
        sut.assertArguments(equalTo: "set -- fileName1")
    }
    
    func test_toArguments_containsTwoFilesArgument() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["fileName1", "fileName2"]
        sut.assertArguments(equalTo: "set -- fileName1 fileName2")
    }
    
    func test_toArguments_escapesSpacesInFileNames() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["file name with spaces"]
        sut.assertArguments(equalTo: "set -- file name with spaces")
        
        sut.options.filePaths = ["level 1/level 2"]
        sut.assertArguments(equalTo: "set -- level 1/level 2")
    }
    
    func test_toArguments_handlesFileNamesWithDashes() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["level1/level2/level3"]
        sut.assertArguments(equalTo: "set -- level1/level2/level3")
    }
    
    func test_toArguments_handlesNoCone() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["path"]
        sut.options.noCone = true
        sut.assertArguments(equalTo: "set --no-cone -- path")
    }
    
    func test_toArguments_doesNotContainNoConeWhenNoFiles() {
        var sut = makeSUT()
        
        sut.options.filePaths = []
        sut.options.noCone = true
        sut.assertArguments(equalTo: "")
    }
}

// MARK: - SUT
fileprivate extension GitSparseSetOptionsTest {
    struct SUT: ArgumentConvertible {
        var options: GitSparseSetOptions
        
        func toArguments() -> [String] {
            options.toArguments()
        }
    }
    
    func makeSUT() -> SUT {
        let options = GitSparseSetOptions(filePaths: [])
        
        return SUT(
            options: options)
    }
}
