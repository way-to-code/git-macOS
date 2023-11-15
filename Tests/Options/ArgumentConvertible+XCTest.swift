//
//  ArgumentConvertible+XCTest.swift
//  GitTests
//
//  Created by Max Akhmatov (15.11.2023).
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
import XCTest
import Git

extension ArgumentConvertible {
    func assertArguments(
        doNotContain expectedValue: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let resultedValue = toArguments().joined(separator: " ")
        
        if resultedValue.contains(expectedValue) {
            XCTFail(
                "The resulted options expected NOT to contain `\(expectedValue)`. Received `\(resultedValue)`",
                file: file, line: line)
        }
    }
    
    func assertArguments(
        contain expectedValue: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let resultedValue = toArguments().joined(separator: " ")
        
        if !resultedValue.contains(expectedValue) {
            XCTFail(
                "The resulted options expected to contain `\(expectedValue)`. Received `\(resultedValue)`",
                file: file, line: line)
        }
    }
    
    func assertArguments(
        equalTo expectedValue: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let resultedValue = toArguments().joined(separator: " ")
        
        XCTAssertEqual(
            resultedValue, expectedValue,
            "Unexpected value for the resulting options",
            file: file, line: line
        )
    }
}
