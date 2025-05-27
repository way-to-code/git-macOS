//
//  TestFileStorage.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation
import Git

class TestFileStorage: FileStorage {

    static var sharedContent = Data("{\"name\": \"black\"}".utf8)
    
    func read(contentOf file: Accessible) throws -> Data {
        return type(of: self).sharedContent
    }
    
    func read<T: FileAnnotationRecord>(annotationsOf file: Accessible) -> [T] {
        return []
    }
    
    func write(file: Accessible) throws {
    }
}
