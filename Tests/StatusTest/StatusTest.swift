//
//  StatusTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import XCTest
import Git

class StatusTest: XCTestCase {

    func testStatusesParsing() {
        // General test case for all available statuses
        let input: [String : [GitFileStatus.ModificationState]] = [
            "M " : [.modified, .unmodified],
            " M" : [.unmodified, .modified],
            "A " : [.added, .unmodified],
            " A" : [.unmodified, .added],
            "D " : [.deleted, .unmodified],
            " D" : [.unmodified, .deleted],
            "C " : [.copied, .unmodified],
            " C" : [.unmodified, .copied],
            "R " : [.renamed, .unmodified],
            " R" : [.unmodified, .renamed],
            "U " : [.unmerged, .unmodified],
            " U" : [.unmodified, .unmerged],
            "! " : [.ignored, .unmodified],
            " !" : [.unmodified, .ignored],
            "? " : [.untracked, .unmodified],
            " ?" : [.unmodified, .untracked]
        ]
        
        for (key, statuses) in input {
            let fileStatus = GitFileStatus(path: "", state: key)
            
            XCTAssert(fileStatus.state.index == statuses[0], "File status state parsing failed for key: \(key)")
            XCTAssert(fileStatus.state.worktree == statuses[1], "File status state parsing failed for key: \(key)")
        }
        
        // Test case for all available conflicts
        let conflicts: [String : GitFileStatus.ConflictState] = [
            "DD" : .unmergedDeletedBoth,
            "AU" : .unmergedAddedByUs,
            "UD" : .unmergedDeletedByThem,
            "UA" : .unmergedAddedByThem,
            "DU" : .unmergedDeletedByUs,
            "AA" : .unmergedAddedBoth,
            "UU" : .unmergedModifiedBoth
        ]
        
        for (key, status) in conflicts {
            let fileStatus = GitFileStatus(path: "", state: key)
            
            XCTAssert(fileStatus.hasConflicts, "File conflict state parsing failed. Expected to have conflict for key: \(key)")
            XCTAssert(fileStatus.state.conflict == status, "File conflict state parsing failed. Expected to have conflict for key: \(key)")
        }
        
        // Test cases for wrong input
        let wrongInput: [String] = [
            "",
            "[]  ",
            "__",
            "+"
        ]
        
        for key in wrongInput {
            let fileStatus = GitFileStatus(path: "", state: key)
            
            XCTAssert(fileStatus.hasChangesInIndex == false, "File state parsting failed. Should not have changes for key: \(key)")
            XCTAssert(fileStatus.hasChangesInWorktree == false, "File state parsting failed. Should not have changes for key: \(key)")
            
            XCTAssert(fileStatus.state.index == .unknown, "File state parsting failed. Incorrect status for key: \(key)")
            XCTAssert(fileStatus.state.worktree == .unknown, "File state parsting failed. Incorrect status for key: \(key)")
        }
    }
}
