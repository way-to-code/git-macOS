//
//  RepositoryTest.swift
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

import XCTest
import Git

protocol RepositoryTest {
    
    var repositoryBundleName: String { get }
    
    /// Creates a repository instance
    func createRepository() -> GitRepository?
}

extension RepositoryTest {
    
    func createRepository() -> GitRepository? {
        let bundleURL = URL(fileURLWithPath: path(toFile: repositoryBundleName))
        
        // As xcode can not work with hidden files rename git to .git
        let gitURL = bundleURL.appendingPathComponent("git")
        let dotGitURL = bundleURL.appendingPathComponent(".git")
        
        try? FileManager.default.moveItem(at: gitURL, to: dotGitURL)
        
        return try? GitRepository(atPath: bundleURL.path)
    }
    
    func createEmptyRepositoryWithCommit() throws -> GitRepository {
        let path = try FileManager.createTemporaryDirectory()
        let repository = try GitRepository.create(atPath: path, options: .default)
        
        let filePath = "\(path)/tmp.file"
        try "".write(toFile: filePath, atomically: true, encoding: .utf8)
        try repository.add(files: [filePath])
        
        try repository.commit(options: .init(message: "Initial commit", files: .all))
        return repository
    }
    
    fileprivate func path(toFile fileName: String) -> String {
        guard let dataPath = Bundle(for: Self.self as! AnyClass).path(forResource: fileName, ofType: "") else {
            XCTFail("Unable to load resource \(fileName)"); return ""
        }
        
        guard dataPath.count > 0 else {
            XCTFail("Unable to load resource \(fileName)"); return ""
        }
        
        return dataPath
    }
}
