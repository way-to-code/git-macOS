//
//  GitRepository.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

public extension GitRepository {
    
    func listStatus(options: GitStatusOptions = .default) throws -> GitFileStatusList {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let task = StatusTask(owner: self, options: options)
        try task.run()
        
        return task.status
    }
}
