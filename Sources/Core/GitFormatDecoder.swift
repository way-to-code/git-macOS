//
//  GitFormatDecoder.swift
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

import Cocoa

class GitFormatDecoder {

    // MARK: - Public
    /// Converts an output provided by git command line (with outputWriter formatter) to an array of objects
    func decode<T: Decodable>(_ formatOutput: String) -> [T] {
        guard formatOutput.count > 0 else {
            // empty output, fallback
            return []
        }
        
        var objects = [T]()
        
        // remove trailing newlines and whitespaces
        let records = formatOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        for record in records.components(separatedBy: GitFormatEncoder.lineSeparator) {
            guard record.count > 0 else { continue }
            
            // before decoding a record from JSON, we must ensure, it is properly escaped
            let escapedRecord = escapedSequence(record)
            
            guard let data = escapedRecord.data(using: .utf8) else {
                continue
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard let object = try? decoder.decode(T.self, from: data) else {
                continue
            }
            
            objects.append(object)
        }
        
        return objects
    }
    
    func decode<T: Decodable>(_ formatOutput: String) -> T? {
        let objects: [T] = decode(formatOutput)
        return objects.first
    }
    
    /// Escapes a string obtained from git command line tool built with --format option
    ///
    /// - Parameter sequence: A string that needs to be escaped for JSON format
    /// - Returns: A JSON-escaped string
    func escapedSequence(_ sequence: String) -> String {
        var sequence = sequence.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // see https://www.json.org/json-ru.html
        sequence = sequence.replacingOccurrences(of: "\\", with: "\\\\")
        sequence = sequence.replacingOccurrences(of: "//", with: "////")
        sequence = sequence.replacingOccurrences(of: "\"", with: "\\\"")
        sequence = sequence.replacingOccurrences(of: "\n", with: "\\n")
        sequence = sequence.replacingOccurrences(of: "\t", with: "\\t")
        sequence = sequence.replacingOccurrences(of: "\r", with: "\\r")
        sequence = sequence.replacingOccurrences(of: "\0", with: "\\u0000")
        sequence = sequence.replacingOccurrences(of: "\u{8}", with: "\\u0008") // backspace \b
        
        // at last, replace special quotes to a normal quotes
        sequence = sequence.replacingOccurrences(of: GitFormatEncoder.quotes, with: "\"")
        return sequence
    }
}
