//
//  GitFormatEncoder.swift
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

@dynamicMemberLookup
class GitFormatEncoder {
    
    /// Encoding strategy for % symbol
    enum PercentEncodingStrategy {
        
        /// In case a percent is found, the content will be wrapped with quotes (to provide a simple JSON)
        case wrapWithQuotes
        
        /// In case a percent is found, no wrapping is happen. May be used for conditional formatting which already have nessesary escaping
        case keepUntouch
    }
    
    static var lineSeparator: String {
        return "$(END_OF_LINE)$"
    }
    
    static var quotes: String {
        return "$(^QUOTES^)$"
    }

    // in order to use ordered key/values, use two separate arrays
    private var keys = [String]()
    private var values = [String]()
    
    /// A strategy for wrapping % character into quotes
    var percentEscapingStrategy = PercentEncodingStrategy.keepUntouch

    subscript(dynamicMember key: String) -> String? {
        set {
            if let index = keys.firstIndex(where: {$0 == key}), index >= 0 {
                // an object already exists
                guard let value = newValue else {
                    keys.remove(at: index)
                    values.remove(at: index)
                    return
                }

                values[index] = value
            }
            
            guard let value = newValue else {
                return
            }
            
            // object doen't exist, add it
            keys.append(key)
            values.append(value)
        }
        
        get {
            guard let index = keys.firstIndex(where: {$0 == key}), index >= 0 else {
                // value not found
                return nil
            }
            
            return values[index]
        }
    }

    /// Converts JSON structure to git appropriate format for --format command
    func encode() -> String {
        var output = "--format={"
        
        let quotes = GitFormatEncoder.quotes
        
        for (index, key) in keys.enumerated() {
            let value = values[index]
            
            // add a key
            output += "\(quotes)\(key)\(quotes):"
            
            if value.starts(with: "%") {
                if percentEscapingStrategy == .keepUntouch {
                    // already have formatting (for conditional bindings for example)
                    output.append(value)
                } else {
                    // just need to wrap into quotes
                    output.append("\(quotes)\(value)\(quotes)")
                }
            } else {
                output.append("\(quotes)%(\(value))\(quotes)")
            }
            
            output += ","
        }

        return output.trimmingCharacters(in: CharacterSet(charactersIn: ",")) + "}\(GitFormatEncoder.lineSeparator)"
    }
}
