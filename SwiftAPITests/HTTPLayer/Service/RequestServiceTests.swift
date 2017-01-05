//
//  RequestServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 04.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RequestServiceTests: XCTestCase {
    
    var rootURL: URL!
    var requestService: RequestService!

    override func setUp() {
        super.setUp()

        rootURL = URL(string: "https://jsonplaceholder.typicode.com")!
        requestService = RequestService()
    }

    override func tearDown() {
        rootURL = nil
        requestService = nil
        super.tearDown()
    }
    
    func testHttpGetRequest() {
        let url = rootURL.appendingPathComponent("posts/1")
        let responseExpectation = expectation(description: "responseResponseAction")

        var performedSuccess = false
        let success = ResponseAction.success {(_) in
            performedSuccess = true
            responseExpectation.fulfill()
        }

        var performedFailure = false
        var responseError: Error?
        let failure = ResponseAction.failure {(error) in
            performedFailure = true
            responseError = error
            responseExpectation.fulfill()
        }

        let request = HttpDataRequest(url: url, method: .get, onSuccess: success, onFailure: failure)
        requestService.sendHTTPRequest(request)

        self.waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Something went wrong: \(error!.localizedDescription)")
            XCTAssertFalse(performedFailure, "Request finished with error? \(responseError?.localizedDescription)")
            XCTAssertTrue(performedSuccess)
        }
    }
}
