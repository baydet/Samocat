//
//  BaseTestCase.swift
//  Samocut
//
//  Created by Orangesoft Developer on 14.04.17.
//  Copyright © 2017 Orangesof. All rights reserved.
//

import XCTest

class BaseTestCase: XCTestCase {
    
    static var baseURL: String {
        return "https://www.youtube.com/watch?v=iZ7dyaPeReY"
    }
    var baseURL: String {
        return BaseTestCase.baseURL
    }
    
    // Unsafe method
    func stringFromFile(fileName: String, type: String) -> String {
        let path = Bundle(for: self.classForCoder).path(forResource: fileName, ofType: type)
        do {
            return try String(contentsOfFile: path!)
        } catch {
            return ""
        }
    }
}
