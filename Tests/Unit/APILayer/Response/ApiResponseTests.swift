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
        XCTAssertTrue(response!.statusCode.isInternalError)
        XCTAssertEqual(response?.expectedContentLength, -1)
        XCTAssertEqual(response?.body, data)
    }

    func testPrettyPrinter() {
        let data = "{ \"number\": 10}".data(using: .utf8)!
        let httpResponse = HttpResponse(body: data)
        let response = ApiResponse(httpResponse)

        XCTAssertEqual(response?.body, data)
        XCTAssertNotNil(response?.prettyPrintedBody)
    }

    func testPrettyPrinterFailure1() {
        let url = URL(string:"https://www.google.com")!
        let httpResponse = HttpResponse(resourceUrl: url)
        let response = ApiResponse(httpResponse)

        XCTAssertNil(response?.body)
        XCTAssertNil(response?.prettyPrintedBody)
    }

    func testPrettyPrinterFailure2() {
        let data = Data(count: 10)
        let httpResponse = HttpResponse(body: data)
        let response = ApiResponse(httpResponse)

        XCTAssertEqual(response?.body, data)
        XCTAssertNil(response?.prettyPrintedBody)
    }
}
