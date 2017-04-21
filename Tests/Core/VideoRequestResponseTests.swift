//
//  VideoRequestResponseTests.swift
//  Samocut
//
//  Created by Orangesoft Developer on 14.04.17.
//  Copyright © 2017 Orangesof. All rights reserved.
//

import XCTest
@testable import Samocut

class VideoRequestResponseTests: BaseTestCase {
    
    func testVideoResponseWithCorrectURL() {
        let samocut = Samocut()
        let expectation = XCTestExpectation(description: "Fetch video response expectation")
        
        samocut.fetchVideoQualitiesBy(videoURL: URL(string: baseURL)!) { (response: [String : String]?, error: String?) -> Swift.Void   in
            if error == nil && response != nil {
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 15)
    }
    
    func testVideoResponseWithUncorrectURL() {
        let samocut = Samocut()
        let expectation = XCTestExpectation(description: "Fetch video response expectation")
        
        samocut.fetchVideoQualitiesBy(videoURL: URL(string: "https://www.youtube.com/watch?v=")!) { (response: [String : String]?, error: String?) -> Swift.Void   in
            if error != nil && response == nil {
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 15)
    }
    
    func testVideoResponseWithInvalidURL() {
        let samocut = Samocut()
        let expectation = XCTestExpectation(description: "Fetch video response expectation")
        
        samocut.fetchVideoQualitiesBy(videoURL: URL(string: "https://www.youtube.com/watch?v=1")!) { (response: [String : String]?, error: String?) -> Swift.Void   in
            if error != nil && response == nil {
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 15)
    }
    
    func testVideoResponseWithCorrectId() {
        let samocut = Samocut()
        let expectation = XCTestExpectation(description: "Fetch video response expectation")
        let videoId = samocut.videoIdFrom(videoURL: URL(string: baseURL)!)
        
        samocut.fetchVideoQualitiesBy(videoId: videoId!) { (response: [String : String]?, error: String?) -> Swift.Void   in
            if error == nil && response != nil {
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 15)
    }
    
    func testVideoResponseWithEmptyId() {
        let samocut = Samocut()
        let expectation = XCTestExpectation(description: "Fetch video response expectation")
        
        samocut.fetchVideoQualitiesBy(videoId: "") { (response: [String : String]?, error: String?) -> Swift.Void   in
            if error != nil && response == nil {
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 15)
    }
}
