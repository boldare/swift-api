//
//  HttpRequestTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 04.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpDataRequestTests: XCTestCase {

    var rootURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var exampleBody: Data {
        return "Example string.".data(using: .utf8)!
    }

    var exampleSuccessAction: ResponseAction {
        return ResponseAction.success {_ in}
    }

    var exampleFailureAction: ResponseAction {
        return ResponseAction.failure {_ in}
    }

    func testFullConstructor() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let body = exampleBody
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request = HttpDataRequest(url: url, method: method, body: body, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertEqual(request.body, body)
        XCTAssertTrue(success.isEqualByType(with: request.successAction!))
        XCTAssertTrue(failure.isEqualByType(with: request.failureAction!))
        XCTAssertNotNil(request.progress)
    }

    func testUrlRequest() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let body = exampleBody
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request = HttpDataRequest(url: url, method: method, body: body, onSuccess: success, onFailure: failure, useProgress: true)
        let urlRequest = request.urlRequest

        XCTAssertEqual(urlRequest.url, url)
        XCTAssertEqual(urlRequest.httpMethod, method.rawValue)
        XCTAssertEqual(urlRequest.httpBody, body)
    }

    func testHashValue() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let body = exampleBody
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request1 = HttpDataRequest(url: url, method: method, body: body, onSuccess: success, onFailure: failure, useProgress: true)
        let request2 = HttpDataRequest(url: url, method: method, body: nil, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertTrue(request1.hashValue == request1.hashValue)
        XCTAssertFalse(request1.hashValue == request2.hashValue)
    }
}
