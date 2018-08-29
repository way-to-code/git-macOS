//
//  CredentialsProvider.swift
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

/// Enum with all possible errors that can occur by using CredentialsProvider
public enum CredentialsProviderError: Error {
    
    /// May occur in urlByAddingCredentials method. Repository URLs must have a valid url scheme (e.q. http/https/git etc.)
    case repositoryURLSchemeMissing
    
    /// Something is wrong with an URL. Obviosly, it doesn't correspond to RFC 3986
    case repositoryURLMalformed
}

/// Describes a simple provider for authorizing repository actions (like clone)
public protocol CredentialsProvider {
    
    /// Returns an instance of a provider, that does not require authorization at all
    static var anonymousProvider: CredentialsProvider { get }
    
    var username: String { get }
    
    var password: String? { get }
    
    /// Password with escaped characters if needed
    var escapedPassword: String? { get }
    
    /// Constructs a new URL from the specified repository URL adding authorization info
    func urlByAddingCredentials(to sourceURL: URL) throws -> URL
}
