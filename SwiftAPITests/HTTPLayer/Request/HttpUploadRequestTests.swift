//
//  HttpRequestTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 04.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpUploadRequestTests: XCTestCase {

    var rootURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    var exampleResource: URL {
        return documentsUrl.appendingPathComponent("file.jpg")
    }

    var anotherExampleResource: URL {
        return documentsUrl.appendingPathComponent("file2.jpg")
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
        let resource = exampleResource
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request = HttpUploadRequest(url: url, method: method, resourceUrl: resource, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, method)
        XCTAssertEqual(request.resourceUrl, resource)
        XCTAssertTrue(success.isEqualByType(with: request.successAction!))
        XCTAssertTrue(failure.isEqualByType(with: request.failureAction!))
        XCTAssertNotNil(request.progress)
    }

    func testEqualityOfEqualRequests() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.get
        let resource = exampleResource
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request1 = HttpUploadRequest(url: url, method: method, resourceUrl: resource, onSuccess: success, onFailure: failure, useProgress: true)
        let request2 = HttpUploadRequest(url: url, method: method, resourceUrl: resource, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertTrue(request1 == request2)
    }

    func testEqualityOfNotEqualRequests() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.post
        let resource = exampleResource
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request1 = HttpUploadRequest(url: url, method: method, resourceUrl: resource, onSuccess: success, onFailure: failure, useProgress: true)
        let request2 = HttpRequest(url: url, method: method, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertFalse(request1 == request2)
    }

    func testHashValue() {
        let url = rootURL.appendingPathComponent("posts/1")
        let method = HttpMethod.post
        let resource1 = exampleResource
        let resource2 = anotherExampleResource
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request1 = HttpUploadRequest(url: url, method: method, resourceUrl: resource1, onSuccess: success, onFailure: failure, useProgress: true)
        let request2 = HttpUploadRequest(url: url, method: method, resourceUrl: resource2, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertTrue(request1.hashValue == request1.hashValue)
        XCTAssertFalse(request1.hashValue == request2.hashValue)
    }
}
