//
//  HttpFailureResponseTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpFailureResponseTests: XCTestCase {

    private var exampleUrl: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    private var exampleError: Error {
        return NSError(domain: "Test", code: 0, userInfo: nil)
    }

    var exampleBody: Data {
        return "Example string.".data(using: .utf8)!
    }

    @available(*, deprecated)
    func testProperties() {
        let url = exampleUrl
        let error = exampleError
        let response = HttpFailureResponse(url: url, error: error)

        XCTAssertEqual(response.url, url)
        XCTAssertEqual(response.error.localizedDescription, error.localizedDescription)
        XCTAssertEqual(response.expectedContentLength, -1)
        XCTAssertNil(response.mimeType)
        XCTAssertNil(response.textEncodingName)
        XCTAssertNil(response.statusCode)
        XCTAssertNil(response.allHeaderFields)
        XCTAssertNil(response.body)
        XCTAssertNil(response.resourceUrl)
    }

    @available(*, deprecated)
    func testUpdate() {
        let url = exampleUrl
        let error = exampleError
        let response = HttpFailureResponse(url: url, error: error)
        let urlResponse = URLResponse(url: URL(fileURLWithPath: ""), mimeType: "test", expectedContentLength: 500, textEncodingName: "test")

        response.update(with: urlResponse)

        XCTAssertEqual(response.url, url)
        XCTAssertNotNil(response.error.localizedDescription)
        XCTAssertEqual(response.expectedContentLength, -1)
        XCTAssertNil(response.mimeType)
        XCTAssertNil(response.textEncodingName)
        XCTAssertNil(response.statusCode)
        XCTAssertNil(response.allHeaderFields)
        XCTAssertNil(response.body)
        XCTAssertNil(response.resourceUrl)
    }

    @available(*, deprecated)
    func testAppend() {
        let url = exampleUrl
        let error = exampleError
        let response = HttpFailureResponse(url: url, error: error)

        response.appendBody(exampleBody)

        XCTAssertNil(response.body)
    }
}
