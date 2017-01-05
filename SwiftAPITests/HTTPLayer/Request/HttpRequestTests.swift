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

    var rootURL: URL!

    override func setUp() {
        super.setUp()

        rootURL = URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    override func tearDown() {
        rootURL = nil

        super.tearDown()
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
        let success = ResponseAction.success {_, _ in}
        let failure = ResponseAction.failure {_ in}
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
        let success = ResponseAction.success {_, _ in}
        let failure = ResponseAction.failure {_ in}
        let request = HttpRequest(url: url, method: method, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertTrue(success.isEqualByType(with: request.successAction!))
        XCTAssertTrue(failure.isEqualByType(with: request.failureAction!))
        XCTAssertNotNil(request.progress)
    }
}
