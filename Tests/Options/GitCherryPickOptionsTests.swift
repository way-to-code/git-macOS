//
//  GitCherryPickOptionsTests.swift
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

final class GitCherryPickOptionsTests: XCTestCase {
    func test_toArguments_properlyConvertsChangeSet() {
        let changeSet = "specific change set"
        let sut = makeSUT(changeSet: changeSet)
        
        sut.assertArguments(contain: changeSet)
    }
    
    func test_toArguments_properlyConvertsShouldCommit() {
        let sut = makeSUT()
        
        sut.options.shouldCommit = false
        sut.assertArguments(contain: "-n")
        
        sut.options.shouldCommit = true
        sut.assertArguments(doNotContain: "-n")
    }
    
    func test_toArguments_propertyConvertsMainline() {
        let sut = makeSUT()
        
        sut.options.mainline = 1
        sut.assertArguments(contain: "-m 1")
        
        sut.options.mainline = 2
        sut.assertArguments(contain: "-m 2")

        sut.options.mainline = .none
        sut.assertArguments(doNotContain: "-m")
    }
}

// MARK: - SUT
fileprivate extension GitCherryPickOptionsTests {
    struct SUT: ArgumentConvertible {
        var options: GitCherryPickOptions
        
        func toArguments() -> [String] {
            options.toArguments()
        }
    }
    
    func makeSUT(changeSet: String = "any change set") -> SUT {
        let options = GitCherryPickOptions(changeset: changeSet)
        
        return SUT(
            options: options)
    }
}
