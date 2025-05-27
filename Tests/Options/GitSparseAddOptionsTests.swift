//
//  GitSparseAddOptionsTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation
import Git
import XCTest

final class GitSparseAddOptionsTest: XCTestCase {
    func test_toArguments_doesNotContainOptionsWhenNoFilePathsProvided() {
        var sut = makeSUT()
        
        sut.options.filePaths = []
        sut.assertArguments(equalTo: "")
    }
    
    func test_toArguments_containsSingleFileArgument() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["fileName1"]
        sut.assertArguments(equalTo: "add -- fileName1")
    }
    
    func test_toArguments_containsTwoFilesArgument() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["fileName1", "fileName2"]
        sut.assertArguments(equalTo: "add -- fileName1 fileName2")
    }
    
    func test_toArguments_escapesSpacesInFileNames() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["file name with spaces"]
        sut.assertArguments(equalTo: "add -- file name with spaces")
        
        sut.options.filePaths = ["level 1/level 2"]
        sut.assertArguments(equalTo: "add -- level 1/level 2")
    }
    
    func test_toArguments_handlesFileNamesWithDashes() {
        var sut = makeSUT()
        
        sut.options.filePaths = ["level1/level2/level3"]
        sut.assertArguments(equalTo: "add -- level1/level2/level3")
    }
}

// MARK: - SUT
fileprivate extension GitSparseAddOptionsTest {
    struct SUT: ArgumentConvertible {
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
