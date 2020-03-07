//
//  MergeTask.swift
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

class MergeTask: RepositoryTask, TaskRequirable {
    
    // MARK: - TaskRequirable
    var name: String {
        return "merge"
    }
    
    required init(owner: GitRepository, options: ArgumentConvertible) {
        super.init(owner: owner)
        
        workingPath = repository.localPath
        add(options.toArguments())
    }
    
    func handle(output: String) {
    }
    
    func handle(errorOutput: String) {
    }
    
    func finish(terminationStatus: Int32) throws {
        if parameters.contains("--abort"), terminationStatus != 0 {
            throw RepositoryError.unableToAbortMerge(message: output ?? "Unknown error")
        }
        
        if terminationStatus != 0 {
            if checkForConflict() {
                throw RepositoryError.mergeFinishedWithConflicts
            } else {
                throw RepositoryError.mergeHasBeenFallen(message: output ?? "Unknown error")
            }
        }
        
        repository.delegate?.repository(repository, didFinishMerge: output)
    }
    
    private func checkForConflict() -> Bool {
        guard let output = self.output else {
            return false
        }
        
        // This is not a good solution for checking a conflict like this. However, any other solution has not been found.
        let pattern = "(CONFLICT \\(.+\\):)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return true
        }
        
        let results = regex.matches(in: output, range: NSRange(output.startIndex..., in: output))
        return results.count > 0
    }
}
