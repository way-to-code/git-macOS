//
//  LogTest.swift
//  Git-macOS
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

class LogTest: FileTest {
    
    var repository: GitRepository? {
        let bundleURL = URL(fileURLWithPath: pathToFile(named: "LogRepository.bundle"))
        
        // As xcode can not work with hidden files rename git to .git
        let gitURL = bundleURL.appendingPathComponent("git")
        let dotGitURL = bundleURL.appendingPathComponent(".git")
        
        try? FileManager.default.moveItem(at: gitURL, to: dotGitURL)
        
        return GitRepository(at: bundleURL.path)
    }

    func testFetchingLog() {
        guard let repository = self.repository else {
            XCTFail("Unable to initialize repository for tests")
            return
        }

        guard let log = try? repository.listLogRecords() else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssert(log.records.count == 2)
    }
    
    func testFetchingLogLimit() {
        guard let repository = self.repository else {
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
        guard let repository = self.repository else {
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
}
