//
//  GitCherryPickOptionsTests.swift
//  GitTests
//
//  Created by Max Akhmatov (09.04.2024).
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
