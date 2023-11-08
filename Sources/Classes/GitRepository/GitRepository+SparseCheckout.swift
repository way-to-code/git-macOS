//
//  GitRepository+SparseCheckout.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
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

import Foundation

public extension GitRepository {
    func sparseCheckoutAdd(files: [String]) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let options = GitSparseAddOptions(filePaths: files)
        
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
