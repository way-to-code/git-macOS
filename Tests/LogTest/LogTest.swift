//
//  LogTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import XCTest
import Git

class LogTest: XCTestCase, RepositoryTest {
    
    var repositoryBundleName: String {
        return "LogRepository.bundle"
    }

    func testFetchingLog() {
        guard let repository = createRepository() else {
            XCTFail("Unable to initialize repository for tests")
            return
        }

        guard let log = try? repository.listLogRecords() else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssertEqual(log.records.count, 2)
    }
    
    /// Tests fetching log from different threads simulateosly
    func testFetchingLogAsync() {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 10
        
        for _ in 1...10 {
            DispatchQueue.global(qos: .background).async {
                self.testFetchingLog()
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testFetchingLogLimit() {
        guard let repository = createRepository() else {
            XCTFail("Unable to initialize repository for tests")
            return
        }
        
        let options = GitLogOptions()
        options.limit = 1
        
        guard let log = try? repository.listLogRecords(options: options) else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssert(log.records.count == 1)
    }
    
    func testFetchingLogDates() {
        guard let repository = createRepository() else {
            XCTFail("Unable to initialize repository for tests")
            return
        }
        
        // # case 1
        let options = GitLogOptions()
        
        options.after = Formatter.iso8601.date(from: "2018-10-10T00:00:00")
        guard let log1 = try? repository.listLogRecords(options: options) else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssert(log1.records.count == 2)
        
        // # case 2
        options.after = Formatter.iso8601.date(from: "2030-01-01T00:00:00")
        guard let log2 = try? repository.listLogRecords(options: options) else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssert(log2.records.count == 0)
        
        // # case 3
        options.after = nil
        options.before = Formatter.iso8601.date(from: "2030-01-01T00:00:00")
        guard let log3 = try? repository.listLogRecords(options: options) else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssert(log3.records.count == 2)
        
        // # case 4
        options.after = nil
        options.before = Formatter.iso8601.date(from: "2000-01-01T00:00:00")
        guard let log4 = try? repository.listLogRecords(options: options) else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssert(log4.records.count == 0)
    }
    
    func test_listLogRecords_returnsParentHashes() {
        guard let repository = createRepository() else {
            XCTFail("Unable to initialize repository for tests")
            return
        }

        guard let log = try? repository.listLogRecords() else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        guard log.records.count == 2 else {
            return
        }
        
        XCTAssertEqual(log.records[0].parentHashes, "648bc2c3b21ce4b5f1ec916d5d7b950d0e7ba5d1")
        XCTAssertEqual(log.records[1].parentHashes, "")
    }
}
