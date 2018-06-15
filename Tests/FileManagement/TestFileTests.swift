//
//  TestFileTests.swift
//  GitTests
//
//  Copyright (c) 2018 Max A. Akhmatov
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
