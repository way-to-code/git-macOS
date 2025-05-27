//
//  TestFileTests.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import XCTest
import Git

class TestFile: File<TestContentCoder> {
}

class TestFileTests: XCTestCase {
    
    func testFileIntegration() {
        let storage = TestFileStorage()
        let file = TestFile(relativePath: "empty", in: storage)
        try? file.read()
        
        // ensure that a content is properly set on a file
        XCTAssert(file.content == TestFileStorage.sharedContent)
        
        // ensure that a content is properly set on a coder
        XCTAssert(file.coder.content == TestFileStorage.sharedContent)
    }
}
