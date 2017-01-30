//
//  ApiResponseTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ApiResponseTests: XCTestCase {
    
    func testNilConstructor() {
        let response = ApiResponse(nil)

        XCTAssertNil(response)
    }

    func testEmptyConstructor() {
        let data = Data(count: 10)
        let httpResponse = HttpResponse(body: data)
        let response = ApiResponse(httpResponse)

        XCTAssertNotNil(response)
        XCTAssertNil(response?.url)
        XCTAssertNil(response?.mimeType)
        XCTAssertNil(response?.textEncodingName)
        XCTAssertNil(response?.allHeaderFields)
        XCTAssertNil(response?.resourceUrl)
        XCTAssertTrue(response!.statusCode.isInternalErrorStatusCode)
        XCTAssertEqual(response?.expectedContentLength, -1)
        XCTAssertEqual(response?.body, data)
    }
}
