//
//  JSONFormatterTest.swift
//  Git-Tests
//
//  Created by Max Akhmatov on 08/06/2018.
//

import XCTest

fileprivate struct DecoderTestEntity: Decodable {
    var content: String
}

class JSONFormatterTest: XCTestCase {
    
    func testEncoderCollection() {
        let encoder = GitFormatEncoder()
        
        encoder.name = "test"
    }

    func testFormatEncoder() {
        let encoder = GitFormatEncoder()
        
        // check a single value is added
        encoder.name = "value"
        
        let case1 = "--format={\"name\":\"%(value)\"}\(GitFormatEncoder.lineSeparator)"
        let encoded1 = encoder.encode().replacingOccurrences(of: GitFormatEncoder.quotes, with: "\"")
        XCTAssert(case1 == encoded1)
        
        // check many values
        encoder.surname = "value2"
        
        let case2 = "--format={\"name\":\"%(value)\",\"surname\":\"%(value2)\"}\(GitFormatEncoder.lineSeparator)"
        let encoded2 = encoder.encode().replacingOccurrences(of: GitFormatEncoder.quotes, with: "\"")
        
        XCTAssert(case2 == encoded2)
    }
    
    func testFormatDecoder() {
        let encoder = GitFormatEncoder()
        let decoder = GitFormatDecoder()
        
        /// A characters that should be escaped in JSON
        let jsonEscapeCharacters = ["\0",
                                    "\n",
                                    "\r",
                                    "\t",
                                    "\\",
                                    "//",
                                    "\"",
                                    "\u{8}"]
        
        for character in jsonEscapeCharacters {
            encoder.content = character
            
            // ensure format is removed
            let jsonContent = encoder.encode().replacingOccurrences(of: "--format=", with: "")
            
            let object: DecoderTestEntity? = decoder.decode(jsonContent)
            XCTAssert(object != nil, "Unable to decode an object for character: \(character)")
        }
    }
}
