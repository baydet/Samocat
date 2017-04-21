//
//  ParseVideoQualityTests.swift
//  Samocut
//
//  Created by Orangesoft Developer on 14.04.17.
//  Copyright © 2017 Orangesof. All rights reserved.
//

import XCTest
@testable import Samocut

class ParseVideoQualityTests: BaseTestCase {
    
    func videoInformationFromFile() -> String {
        return self.stringFromFile(fileName: "video_information", type: "txt")
    }
    
    func testVideoQualityParse() {
        let samocut = Samocut()
        let data = videoInformationFromFile()
        let components = samocut.parse(URLString: data)
        XCTAssertNotNil(components?["url_encoded_fmt_stream_map"])
        let qualities = samocut.parseVideoComponentsFrom(videoInformation: components!)
        XCTAssertNotNil(qualities?["small"])
        XCTAssertNotNil(qualities?["medium"])
        XCTAssertNotNil(qualities?["hd720"])
        XCTAssert(qualities!["hd720"]!.contains("http"))
        XCTAssertNotNil(URL(string: qualities!["hd720"]!))
    }
    
    func testVideoQulaityWithIncorrectDataParse() {
        let samocut = Samocut()
        XCTAssertNil(samocut.parseVideoComponentsFrom(videoInformation: ["" : ""]))
        XCTAssertNil(samocut.parseVideoComponentsFrom(videoInformation: ["url_encoded_fmt_stream_map" : ""]))
        XCTAssertNil(samocut.parseVideoComponentsFrom(videoInformation: ["url_encoded_fmt_stream_map" : "itag=22&quality=hd720&type=video%2Fmp4%3B+codecs%3D%22avc1.64001F%2C+mp4a.40.2%22"]))
    }
}
