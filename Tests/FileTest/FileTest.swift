//
//  FileTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

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
