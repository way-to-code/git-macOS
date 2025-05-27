//
//  InitTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

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
