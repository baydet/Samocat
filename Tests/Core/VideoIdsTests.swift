//
//  VideoIdsTests.swift
//  Samocut
//
//  Created by Orangesoft Developer on 14.04.17.
//  Copyright © 2017 Orangesof. All rights reserved.
//

import XCTest
@testable import Samocut

class VideoIdsTests: BaseTestCase {
    
    func videoIdFrom(URLString: String) -> String? {
        let samocut = Samocut()
        if let url = URL(string: URLString) {
            return samocut.videoIdFrom(videoURL: url)
        }
        return nil
    }
    
    func testEmptyURL() {
        XCTAssertEqual(videoIdFrom(URLString: ""), nil)
    }
    
    func testNoneYouTubeURL() {
        XCTAssertEqual(videoIdFrom(URLString: "https://www.google.com/"), nil)
    }
    
    func testBaseURL() {
        XCTAssertEqual(videoIdFrom(URLString: baseURL), "iZ7dyaPeReY")
    }
    
    func testShareURL() {
        XCTAssertEqual(videoIdFrom(URLString: "https://youtu.be/iZ7dyaPeReY"), "iZ7dyaPeReY")
    }
    
    func testURLWithTime() {
        XCTAssertEqual(videoIdFrom(URLString: "https://youtu.be/iZ7dyaPeReY?t=2m9s"), "iZ7dyaPeReY")
    }
    
    func testEmbedURL() {
        XCTAssertEqual(videoIdFrom(URLString: "http://www.youtube.com/embed/iZ7dyaPeReY"), "iZ7dyaPeReY");
    }
    
    func testURLWithoutId() {
        XCTAssertEqual(videoIdFrom(URLString: "http://www.youtube.com/"), nil)
    }
    
    func testURLWithEmptyId() {
        XCTAssertEqual(videoIdFrom(URLString: "https://www.youtube.com/watch?v="), nil)
    }
    
    func testURLWithoutWorldWideWeb() {
        XCTAssertEqual(videoIdFrom(URLString: "http://youtube.com/embed/iZ7dyaPeReY"), "iZ7dyaPeReY");
    }
}
