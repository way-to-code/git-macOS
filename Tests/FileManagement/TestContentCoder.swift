//
//  TestContentCoder.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation
import Git

struct TestContentData: Codable {
    var name: String
}

class TestContentCoder: FileCoder {
    
    final override func encode() throws -> Data {
        return content
    }
}
