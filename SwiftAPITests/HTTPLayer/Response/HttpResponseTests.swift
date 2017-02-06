//
//  HttpFailureResponseTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpResponseTests: XCTestCase {

    private var exampleUrl: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var exampleBody: Data {
        return "Example string.".data(using: .utf8)!
    }

    var anotherExampleBody: Data {
        return "Another example string.".data(using: .utf8)!
    }

    func testDataConstructor() {
        let body = exampleBody
        let response = HttpResponse(body: body)

        XCTAssertEqual(response.body, body)
        XCTAssertNil(response.url)
        XCTAssertNil(response.mimeType)
        XCTAssertEqual(response.expectedContentLength, Int64(-1))
        XCTAssertNil(response.textEncodingName)
        XCTAssertNil(response.statusCode)
        XCTAssertNil(response.allHeaderFields)
        XCTAssertNil(response.resourceUrl)
    }

    func testUrlConstructor() {
        let url = exampleUrl
        let response = HttpResponse(resourceUrl: url)

        XCTAssertEqual(response.resourceUrl, url)
        XCTAssertNil(response.url)
        XCTAssertNil(response.mimeType)
        XCTAssertEqual(response.expectedContentLength, Int64(-1))
        XCTAssertNil(response.textEncodingName)
        XCTAssertNil(response.statusCode)
        XCTAssertNil(response.allHeaderFields)
        XCTAssertNil(response.body)
    }

    func testUrlResponseConstructor() {
        let url = exampleUrl
        let mimeType = "TestMimeType"
        let length = 888
        let encoding = "TestEncoding"
        let urlResponse = URLResponse(url: url, mimeType: mimeType, expectedContentLength: length, textEncodingName: encoding)
        let response = HttpResponse(urlResponse: urlResponse)

        XCTAssertEqual(response.url, url)
        XCTAssertEqual(response.mimeType, mimeType)
        XCTAssertEqual(response.expectedContentLength, Int64(length))
        XCTAssertEqual(response.textEncodingName, encoding)
        XCTAssertNil(response.statusCode)
        XCTAssertNil(response.allHeaderFields)
        XCTAssertNil(response.resourceUrl)
        XCTAssertNil(response.body)
    }

    func testUpdate() {
        let url1 = exampleUrl
        let mimeType1 = "TestMimeType"
        let length1 = 888
        let encoding1 = "TestEncoding"
        let urlResponse1 = URLResponse(url: url1, mimeType: mimeType1, expectedContentLength: length1, textEncodingName: encoding1)
        let response = HttpResponse(urlResponse: urlResponse1)

        let url2 = URL(fileURLWithPath: "")
        let mimeType2 = "AnotherTestMimeType"
        let length2 = 9999
        let encoding2 = "AnotherTestEncoding"
        let urlResponse2 = URLResponse(url: url2, mimeType: mimeType2, expectedContentLength: length2, textEncodingName: encoding2)

        response.update(with: urlResponse2)

        XCTAssertEqual(response.url, url2)
        XCTAssertEqual(response.mimeType, mimeType2)
        XCTAssertEqual(response.expectedContentLength, Int64(length2))
        XCTAssertEqual(response.textEncodingName, encoding2)
        XCTAssertNil(response.statusCode)
        XCTAssertNil(response.allHeaderFields)
        XCTAssertNil(response.resourceUrl)
        XCTAssertNil(response.body)
    }

    func testAppend() {
        let body1 = exampleBody
        let body2 = anotherExampleBody
        var comboBody = body1
        comboBody.append(body2)

        let response = HttpResponse(body: body1)
        response.appendBody(body2)

        XCTAssertNotEqual(response.body, body1)
        XCTAssertNotEqual(response.body, body2)
        XCTAssertEqual(response.body, comboBody)
    }
}
