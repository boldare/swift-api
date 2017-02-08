//
//  RestErrorResponseTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 08.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RestErrorResponseTests: XCTestCase {
    
    func testSimpleConstructor() {
        let error = NSError(domain: "test", code: -8, userInfo: nil)
        let response = RestErrorResponse(error: error)

        XCTAssertEqual(response.error as NSError, error)
        XCTAssertNil(response.body)
        XCTAssertNil(response.aditionalInfo)
    }
    
    func testFullConstructor() {
        let error = NSError(domain: "test", code: -8, userInfo: nil)
        let body = Data(base64Encoded: "test")
        let info = ["test" : "test"]
        let response = RestErrorResponse(error: error, body: body, aditionalInfo: info)

        XCTAssertEqual(response.error as NSError, error)
        XCTAssertEqual(response.body, body)
        XCTAssertEqual(response.aditionalInfo?.count, 1)
        XCTAssertEqual(response.aditionalInfo?.first?.name, info.first?.key)
        XCTAssertEqual(response.aditionalInfo?.first?.value, info.first?.value)
    }
}
