//
//  StashTest.swift
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

class StashTest: FileTest {
    
    var repository: GitRepository? {
        let bundleURL = URL(fileURLWithPath: pathToFile(named: "LogRepository.bundle"))
        
        // As xcode can not work with hidden files rename git to .git
        let gitURL = bundleURL.appendingPathComponent("git")
        let dotGitURL = bundleURL.appendingPathComponent(".git")
        
        try? FileManager.default.moveItem(at: gitURL, to: dotGitURL)
        
        return GitRepository(at: bundleURL.path)
    }
    
    func test1ListingStash() {
        guard let repository = self.repository else {
            XCTFail("Unable to initialize repository for tests")
            return
        }
        
        guard let stash = try? repository.listStashRecords() else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure there are proper number of records
        XCTAssert(stash.records.count == 2)
    }
    
    func test2StashIndex() {
        guard let repository = self.repository else {
            XCTFail("Unable to initialize repository for tests")
            return
        }
        
        guard let stash = try? repository.listStashRecords() else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        for (index, record) in stash.records.enumerated() {
            // ensure an index is correct
            XCTAssert(record.stackIndex == index)
        }
    }
    
    func test3StashCreate() {
        guard let repository = self.repository else {
            XCTFail("Unable to initialize repository for tests")
            return
        }

        // #1 use a custom message
        let testCase1Message = "Stashing test changes"
        createStash(message: testCase1Message, repository: repository)
        
        // #2 use empty message
        createStash(message: nil, repository: repository)

        // read stashes
        guard let stash = try? repository.listStashRecords() else {
            XCTFail("Unable to load records from repository")
            return
        }
        
        // ensure a new stash records have been added
        XCTAssert(stash.records.count == 4)
        
        // verify message is applied correctly
        if stash.records.count > 1 {
            XCTAssert(stash.records[1].subject.contains(testCase1Message))
        }
    }
    
    func test4StashApply() {
        guard let repository = self.repository else {
            XCTFail("Unable to initialize repository for tests")
            return
        }
        
        // #1 - default options
        do {
            try repository.stashApply()
        } catch {
            XCTFail("Unable to apply a stash")
        }
        
        // #2 - error case
        do {
            try repository.stashApply()
            XCTFail("A stash error must be occured here")
        } catch {
            // test #2 must catch an error and never produce a successful code above
        }
        
        // clean up
        do {
            let options = GitStashOptions()
            options.stashAll = true
            
            createFile(named: "testStashApplyByRecord.txt", in: repository)
            let record = try repository.stashCreate(options: options)
            
            if record == nil {
                XCTFail("Stash record has not been created")
            }
            
            try repository.stashApply(options: GitStashApplyOptions(stash: record))
        } catch {
            XCTFail("An error occured while trying to apply a stash. Error: \(error)")
        }
    }
    
    func test5StashDrop() {
        guard let repository = self.repository else {
            XCTFail("Unable to initialize repository for tests")
            return
        }
        
        // #1 - dropping the latest stash
        var stashes: GitStashRecordList!
        
        do {
            stashes = try repository.listStashRecords()
        } catch {
            XCTFail("Unable to get stash records")
        }
        
        let numberOfStashes1 = stashes.records.count
        try? repository.stashDrop(record: nil)
        
        do {
            stashes = try repository.listStashRecords()
        } catch {
            XCTFail("Unable to get stash records")
        }
        
        // ensure stash records are decreased
        XCTAssert(stashes.records.count == numberOfStashes1 - 1)
        
        // #2 - dropping a stash by a record
        guard let record = stashes.records.last else {
            XCTFail("Dropping test #2 has been fallen due to inconsistent state. Record was not found, but must be")
            return
        }
        
        let numberOfStashes2 = stashes.records.count
        
        do {
            try repository.stashDrop(record: record)
        } catch {
            XCTFail("Dropping test #2 has been fallen. Error: \(error)")
            return
        }
        
        do {
            stashes = try repository.listStashRecords()
        } catch {
            XCTFail("Unable to get stash records")
        }
        
        // ensure stash records are decreased
        XCTAssert(stashes.records.count == numberOfStashes2 - 1)
    }
    
    private func createFile(named: String, in repository: Repository) {
        guard let path = repository.localPath else {
            XCTFail("Unable to initialize repository for tests")
            return
        }

        // create a new file for stash
        FileManager.default.createFile(atPath: path + "/\(named))",
                                       contents: "testStashCreate\n".data(using: .utf8)!,
                                       attributes: nil)
    }
    
    private func createStash(message: String?, repository: Repository) {
        guard let path = repository.localPath else {
            XCTFail("Unable to initialize repository for tests")
            return
        }

        let options = GitStashOptions(message: message)
        options.stashAll = true
        
        // create a new file for stash
        FileManager.default.createFile(atPath: path + "/new_file.txt",
                                       contents: "testStashCreate\n".data(using: .utf8)!,
                                       attributes: nil)
        
        do {
            try repository.stashCreate(options: options)
        } catch {
            XCTFail("Unable to create a stash with error: \(error)")
        }
    }
}
