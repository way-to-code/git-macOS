//
//  ReferencesTask.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

class CheckoutTask: RepositoryTask, TaskRequirable {
    
    var name: String {
        return "checkout"
    }
    
    convenience init(reference: RepositoryReference, owner: GitRepository) {
        self.init(owner: owner, options: [reference.name.localName])
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as the clone was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.checkoutError(message: output)
        }
    }
}
