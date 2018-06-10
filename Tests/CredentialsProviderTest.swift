//
//  CredentialsProviderTests.swift
//  Git-Tests
//
//  Created by Max Akhmatov on 07/06/2018.
//

import XCTest

class CredentialsProviderTests: XCTestCase {
    
    /// Tests password escape using URL escape-sequence
    func testPasswordEscape() {
        // !   #   $   &   '   (   )   *   +   ,   /   :   ;   =   ?   @   [   ]
        // %21 %23 %24 %26 %27 %28 %29 %2A %2B %2C %2F %3A %3B %3D %3F %40 %5B %5D
        
        // test1: password must be the same
        var provider = GitCredentialsProvider(username: "test", password: "test")
        XCTAssert(provider.escapedPassword == "test")
        
        // test2: escaped
        provider = GitCredentialsProvider(username: "test", password: "!#$\'()*+,/:;=?@[]")
        XCTAssert(provider.escapedPassword == "%21%23%24%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D")
    }
    
    /// Checks if provider correctly adds credentials to URL
    func testAddingCredentialsToURL() {
        let provider = GitCredentialsProvider(username: "user", password: "password")
        let url = URL(string: "git://example.com/repo.git")!
        
        let encodedURL = try! provider.urlByAddingCredentials(to: url)
        XCTAssert(encodedURL.absoluteString == "git://user:password@example.com/repo.git")
    }
    
    /// Checks if provider correctly raises errors when using urlByAddingCredentials
    func testCredentialsToURLErrors() {
        let provider = GitCredentialsProvider(username: "-", password: "-")
        
        // list of malformed urls
        let urls = ["example.com/repo.git",
                    "http:example.com/repo.git",
                    "http:/example.com/repo.git",
                    "/example.com/repo.git"]
        do {
            for url in urls {
                guard let URL = URL(string: url) else { continue }
                _ = try provider.urlByAddingCredentials(to: URL)
            }
        } catch CredentialsProviderError.repositoryURLSchemeMissing {
            XCTAssert(true)
        } catch CredentialsProviderError.repositoryURLMalformed {
            XCTAssert(true)
        } catch {
            // undefined error. must be implemented by provider
            XCTFail("Undefined error is occured during testing errors in urlByAddingCredentials. Please make sure you've implmented this in tests also")
        }
    }
}
