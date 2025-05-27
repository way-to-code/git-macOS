//
//  GitCredentialsProvider.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import Foundation

open class GitCredentialsProvider: CredentialsProvider {
    
    public static var anonymousProvider: CredentialsProvider {
        return GitCredentialsProvider(username: "", password: nil)
    }

    required public init(username: String, password: String?) {
        self.username = username
        self.password = password
    }
    
    // MARK: - Public
    private(set) public var username: String
    private(set) public var password: String?
    
    public func urlByAddingCredentials(to sourceURL: URL) throws -> URL {
        guard username.count > 0 else {
            // anonymous provider, do not add any urls
            return sourceURL
        }
        
        guard sourceURL.scheme != nil else {
            // fallback, wrong URL
            throw CredentialsProviderError.repositoryURLSchemeMissing
        }

        // # add username/password
        guard var urlBuilder = URLComponents(string: sourceURL.absoluteString) else {
            // fallback, wrong URL
            throw CredentialsProviderError.repositoryURLMalformed
        }
        
        if let password = password, password.count > 0 {
            // set a password only if it is provided and not empty
            urlBuilder.password = password
        }
        
        urlBuilder.user = username
        
        return urlBuilder.url!
    }
    
    /// Password with escaped characters if needed
    public var escapedPassword: String? {
        return password?.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
    }
}
