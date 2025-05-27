//
//  ArgumentConvertible.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

fileprivate enum RemoteURLOptions: ArgumentConvertible {
    case called(name: String)
    
    func toArguments() -> [String] {
        switch self {
        case .called(let name):
            return ["get-url", "--all", "\(name)"]
        }
    }
}

class RemoteUrlTask: RepositoryTask, TaskRequirable {

    var name: String {
        return "remote"
    }
    
    /// The list of remote names obtained by the operation
    private(set) var remoteUrls = [URL]()
    private(set) var remoteName: String
    
    required init(owner: GitRepository, remoteName: String) {
        self.remoteName = remoteName
        
        super.init(owner: owner, options: [])
        
        add(RemoteURLOptions.called(name: remoteName).toArguments())
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        guard terminationStatus == 0 else {
            // fallback, as an operation was fallen
            let output = repository.outputByRemovingSensitiveData(from: self.output ?? "")
            throw GitError.remoteUnableToList(message: output)
        }
        
        // parse URLs
        let remotes = self.output?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
        
        for remoteUrl in remotes ?? [] {
            guard let url = URL(string: String(remoteUrl)) else {
                throw GitError.remoteUnableToList(message: "Can not obtain an URL for remote \(self.remoteName)")
            }
            
            remoteUrls.append(url)
        }
    }
}
