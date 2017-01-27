//
//  HttpRequestTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 04.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpDownloadRequestTests: XCTestCase {

    var rootURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    var exampleDestination: URL {
        return documentsUrl.appendingPathComponent("file.jpg")
    }

    var anotherExampleDestination: URL {
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
        let destination = exampleDestination
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request = HttpDownloadRequest(url: url, destinationUrl: destination, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.destinationUrl, destination)
        XCTAssertTrue(success.isEqualByType(with: request.successAction!))
        XCTAssertTrue(failure.isEqualByType(with: request.failureAction!))
        XCTAssertNotNil(request.progress)
    }

    func testHashValue() {
        let url = rootURL.appendingPathComponent("posts/1")
        let destination1 = exampleDestination
        let destination2 = anotherExampleDestination
        let success = exampleSuccessAction
        let failure = exampleFailureAction
        let request1 = HttpDownloadRequest(url: url, destinationUrl: destination1, onSuccess: success, onFailure: failure, useProgress: true)
        let request2 = HttpDownloadRequest(url: url, destinationUrl: destination2, onSuccess: success, onFailure: failure, useProgress: true)

        XCTAssertTrue(request1.hashValue == request1.hashValue)
        XCTAssertFalse(request1.hashValue == request2.hashValue)
    }
}
