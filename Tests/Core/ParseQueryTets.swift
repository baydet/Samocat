//
//  ParseQueryTets.swift
//  Samocut
//
//  Created by Orangesoft Developer on 14.04.17.
//  Copyright © 2017 Orangesof. All rights reserved.
//

import XCTest
@testable import Samocut

class ParseQueryTets: BaseTestCase {
    
    func queryFromFile() -> String {
        return self.stringFromFile(fileName: "url_query", type: "txt")
    }
    
    func testEmptyQueryParse() {
        let samocut = Samocut()
        XCTAssertNil(samocut.parse(URLString: ""))
    }
    
    func testQueryParse() {
        let samocut = Samocut()
        let components = samocut.parse(URLString: queryFromFile())
        XCTAssertNotNil(components)
        XCTAssertEqual(components?["pltype"], "content")
    }
    
    func testDecode() {
        let samocut = Samocut()
        let query = queryFromFile()
        XCTAssert(query.contains("v%3D0"))
        let decoded = samocut.decode(URLString: query)
        XCTAssert(decoded.contains("v=0"))
        let decoded2 = samocut.decode(URLString: "+-=")
        XCTAssert(decoded2 == " -=")
        let percentEncoding = "%<>"
        XCTAssertEqual(samocut.decode(URLString: percentEncoding), percentEncoding)
    }
    
    func testDictionaryExtension() {
        var firstDictionary = ["1" : "1"]
        let secondDictionary = ["2" : "2"]
        
        firstDictionary.append(other: secondDictionary)
        XCTAssertEqual(firstDictionary, ["1" : "1", "2" : "2"])
    }
    
    func testResponseSerialization() {
        let samocut = Samocut()
        let emptyData = "".data(using: .utf8)
        let shortData = "pltype=content&iv_load_policy=1".data(using: .utf8)
        let query = self.stringFromFile(fileName: "video_information", type: "txt").data(using: .utf8)
        let encodingData = "test".data(using: .utf16)

        XCTAssertNil(samocut.serializeVideoResponse(data: emptyData!))
        XCTAssertNil(samocut.serializeVideoResponse(data: shortData!))
        XCTAssertNil(samocut.serializeVideoResponse(data: encodingData!))
        XCTAssertNotNil(samocut.serializeVideoResponse(data: query!))
    }
    
}
