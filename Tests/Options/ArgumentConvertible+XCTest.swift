//
//  ArgumentConvertible+XCTest.swift
//  Git-macOS
//
//  Copyright (c) Created by Max Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 
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
