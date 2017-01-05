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
    
//    func testHttpGetRequest() {
//
//        var responseData: Data?
//        var responseError: Error?
//
//        let url = rootURL.appendingPathComponent("posts/1")
//        let responseExpectation = expectation(description: "responseResponseAction")
//        let success = ResponseAction.success { (data, response) in
//            responseData = data
//            responseExpectation.fulfill()
//        }
//        let failure = ResponseAction.failure { (error) in
//            responseError = error
//            responseExpectation.fulfill()
//        }
//
//        let request = HttpDataRequest(url: url, method: .get, onSuccess: success, onFailure: failure)
//
//        requestService.sendHTTPRequest(request)
//
//        self.waitForExpectations(timeout: 15) { error in
//            XCTAssertNil(error, "Something went wrong: \(error!.localizedDescription)")
//            XCTAssertNil(responseError, "Request failed: \(responseError!.localizedDescription)")
//            XCTAssertNotNil(responseData, "Server is not responding!")
//        }
//    }
}
