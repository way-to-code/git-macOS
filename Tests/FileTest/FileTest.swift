//
//  FileTest.swift
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

/// Basic class for file-based tests
class FileTest: XCTestCase {
    
    /// Loads a file with the specified name and returns it's content as a string
    /// File must be in the Test bundle
    func contentsOfFile(named: String) -> String {
        let dataPath = pathToFile(named: named)
        
        do {
            return try String(contentsOfFile: dataPath)
        } catch {
            XCTFail("Unable to load resource \(named)"); return ""
        }
    }
    
    /// Returns a path to a file in the Test bundle
    ///
    /// - Parameter named: A name of a file including file extension
    func pathToFile(named: String) -> String {
        guard let dataPath = Bundle(for: type(of: self)).path(forResource: named, ofType: "") else {
            XCTFail("Unable to load resource \(named)"); return ""
        }
        
        guard dataPath.count > 0 else {
            XCTFail("Unable to load resource \(named)"); return ""
        }
        
        return dataPath
    }
}
