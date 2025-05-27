//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

public extension GitRepository {
    
    func cherry(options: GitCherryOptions) throws -> GitCherryResult {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let task = CherryTask(owner: self, options: options)
        try task.run()
        
        return task.result
    }
}
