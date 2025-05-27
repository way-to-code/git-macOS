//
//  GitRepository+SparseCheckout.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

public extension GitRepository {
    func sparseCheckoutAdd(files: [String]) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let options = GitSparseAddOptions(filePaths: files)
        
        let task = SparseTask(owner: self, options: options)
        try task.run()
    }
    
    func sparseCheckoutSet(files: [String]) throws {
        try sparseCheckoutSet(
            options: GitSparseSetOptions(filePaths: files))
    }
    
    func sparseCheckoutSet(options: GitSparseSetOptions) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let task = SparseTask(owner: self, options: options)
        try task.run()
    }
}

public extension GitRepository {
    enum SparseCheckoutError: Error {
        /// Occurs when the sparse checkout operation fails
        case unableToPerformOperation(message: String)
    }
}

extension GitRepository.SparseCheckoutError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToPerformOperation(let message):
            return "[GIT.framework] SC0010: Unable perform operation. Error says: '\(message)'"
        }
    }
}

extension GitRepository.SparseCheckoutError: GitCommonError {
    public var rawMessage: String {
        switch self {
        case .unableToPerformOperation(let message):
            return message
        }
    }
}
