//
//  StashApplyTask.swift
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

class StashApplyTask: RepositoryTask, TaskRequirable {
    var name: String {
        return "stash"
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
        guard terminationStatus == 0 else {
            if checkForConflict() {
                // a conflict has been detected
                throw RepositoryError.stashApplyConflict(message: self.output ?? "")
            }
            
            throw RepositoryError.stashApplyError(message: self.output ?? "uknown error")
        }
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
