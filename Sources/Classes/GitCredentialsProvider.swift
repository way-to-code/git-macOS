//
//  GitCredentialsProvider.swift
//  Git-macOS
//
//  Copyright (c) 2018 Max A. Akhmatov
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
