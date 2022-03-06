//
//  InitTest.swift
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

import XCTest
import Git

class InitTest: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testInit() {
        do {
            _ = try GitRepository(atPath: "/Some/Custom/Path/In/The/System")
            XCTFail("This case must produce an exception, as directory does not exist")
        } catch {
        }
        
        // Create temporary directory where to test initialization
        guard let path = try? FileManager.createTemporaryDirectory() else {
            XCTFail("Unable to create temporary directory for init test")
            return
        }
        
        // Ensure directory will be removed after all
        defer {
            FileManager.removeDirectory(atPath: path)
        }
        
        do {
            _ = try GitRepository(atPath: path)
            XCTFail("This case must produce an exception, as git directory does not exist")
        } catch {
        }
        
        // Create an empty file .git
        let url = URL(fileURLWithPath: path).appendingPathComponent(".git")
        FileManager.writeFile(toPath: url.relativePath, content: "")
        
        do {
            _ = try GitRepository(atPath: path)
            XCTFail("This case must produce an exception, as .git is a file")
        } catch {
        }
        
        try? FileManager.createDirectory(atPath: url.relativePath, removeIfExists: true)
        
        do {
            _ = try GitRepository(atPath: path)
        } catch {
            XCTFail("This case must NOT produce an exception as git directory exists")
        }
    }
    
    func testCreate() {
        // Create temporary directory where to test initialization
        guard let path = try? FileManager.createTemporaryDirectory() else {
            XCTFail("Unable to create temporary directory for init test")
            return
        }
        
        // Ensure directory will be removed after all
        defer {
            FileManager.removeDirectory(atPath: path)
        }
        
        do {
            _ = try GitRepository.create(atPath: path)
        } catch {
            XCTFail("Unable to intialize an empty git repository at path \(path). Error: \(error)")
        }
        
        do {
            _ = try GitRepository(atPath: path)
        } catch {
            XCTFail("This case must NOT produce an exception as git repository must be created")
        }
    }
}
