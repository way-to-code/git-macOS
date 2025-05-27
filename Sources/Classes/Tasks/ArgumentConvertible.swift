//
//  ArgumentConvertible.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

protocol ArgumentConvertible {
    
    /// Converts object to an array of arguments
    func toArguments() -> [String]
}
