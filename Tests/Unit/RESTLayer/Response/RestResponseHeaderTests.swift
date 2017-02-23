//
//  RestResponseHeaderTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 15.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RestResponseHeaderTests: XCTestCase {
    
    func testEmptyHeadersList() {
        let responseHeaders = RestResponseHeader.list(with: nil)

        XCTAssertNil(responseHeaders)
    }
    
    func testNotEmptyHeadersList() {
        let headers = ["key" : "value"]
        let responseHeaders = RestResponseHeader.list(with: headers)

        XCTAssertNotNil(responseHeaders)
        XCTAssertEqual(headers.first?.key, responseHeaders?.first?.name)
        XCTAssertEqual(headers.first?.value, responseHeaders?.first?.value)
    }
    
}
