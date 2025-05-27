//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public extension GitRepository {
    
    func cherryPick(options: GitCherryPickOptions) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let task = CherryPickTask(owner: self, options: options)
        try task.run()
    }
}
