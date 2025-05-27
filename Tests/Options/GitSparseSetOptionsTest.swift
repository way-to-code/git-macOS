//
//  GitSparseSetOptionsTest.swift
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
