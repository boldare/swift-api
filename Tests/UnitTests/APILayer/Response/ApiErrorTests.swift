//
//  ApiErrorTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 19.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ApiErrorTests: XCTestCase {
    
    func testNoResponse() {
        let error = ApiError.noResponse

        XCTAssertFalse(error.localizedDescription.isEmpty)
        XCTAssertNotNil(error.localizedDescription.lowercased().range(of: "response"))
    }

    func testStatusCodeError() {
        let statusCode = StatusCode(400)
        let error1 = ApiError.error(for: StatusCode(100))
        let error2 = ApiError.error(for: StatusCode(200))
        let error3 = ApiError.error(for: StatusCode(300))
        let error4 = ApiError.error(for: statusCode)
        let error5 = ApiError.error(for: StatusCode(500))
        let error6 = ApiError.error(for: StatusCode(600))

        XCTAssertNotNil(error1)
        XCTAssertNil(error2)
        XCTAssertNotNil(error3)
        XCTAssertNotNil(error4)
        XCTAssertNotNil(error5)
        XCTAssertNotNil(error6)
        XCTAssertEqual(error4?.localizedDescription, statusCode.description)
    }
}
