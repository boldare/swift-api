//
//  HttpRequestTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 04.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpRequestTests: XCTestCase {

    var rootURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var exampleSuccessAction: ResponseAction {
        return ResponseAction.success {_ in}
    }

    var exampleFailureAction: ResponseAction {
        return ResponseAction.failure {_ in}
    }
    
    func testBasicConstructor() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let request = HttpRequest(url: url, method: method)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertNil(request.successAction)
        XCTAssertNil(request.failureAction)
        XCTAssertNil(request.progress)
    }

    func testFullConstructorWithoutProgress() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request = HttpRequest(url: url, method: method, onSuccess: success, onFailure: failure, useProgress: false)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertTrue(success.isEqualByType(with: request.successAction!))
        XCTAssertTrue(failure.isEqualByType(with: request.failureAction!))
        XCTAssertNil(request.progress)
    }

    func testFullConstructorWithProgress() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request = HttpRequest(url: url, method: method, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertTrue(success.isEqualByType(with: request.successAction!))
        XCTAssertTrue(failure.isEqualByType(with: request.failureAction!))
        XCTAssertNotNil(request.progress)
    }

    func testEqualityOfEqualRequests() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let request1 = HttpRequest(url: url, method: method, useProgress: true)
        let request2 = request1

        XCTAssertTrue(request1 == request2)
    }

    func testEqualityOfNotEqualRequests() {
        let url = rootURL.appendingPathComponent("posts/1")
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request1 = HttpRequest(url: url, method: .get, onSuccess: success, onFailure: failure, useProgress: true)
        let request2 = HttpRequest(url: url, method: .post, onSuccess: success, onFailure: failure, useProgress: true)
        let request3 = HttpRequest(url: url, method: .post, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertFalse(request1 == request2)
        XCTAssertFalse(request1 == request3)
        XCTAssertFalse(request2 == request3)
    }

    func testUrlRequest() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request = HttpRequest(url: url, method: method, onSuccess: success, onFailure: failure, useProgress: true)
        let urlRequest = request.urlRequest

        XCTAssertEqual(urlRequest.url, url)
        XCTAssertEqual(urlRequest.httpMethod, method.rawValue)
    }

    func testHashValue() {
        let url = rootURL.appendingPathComponent("posts/1")
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request1 = HttpRequest(url: url, method: .post, onSuccess: success, onFailure: failure, useProgress: true)
        let request2 = HttpRequest(url: url, method: .get, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertTrue(request1.hashValue == request1.hashValue)
        XCTAssertFalse(request1.hashValue == request2.hashValue)
    }
}
