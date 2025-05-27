//
//  GitCredentialsProvider.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

extension Array: ArgumentConvertible where Element == String {
    
    func toArguments() -> [String] {
        return self
    }
}
