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
        let url = rootURL.appendingPathComponent("posts")

        performTestDataRequest(url: url, method: .get)
    }

    func testHttpPostRequest() {
        let url = rootURL.appendingPathComponent("posts")
        let body = jsonData(with: ["title": "test", "body": "post", "userId": 1] as [String : Any])

        performTestDataRequest(url: url, method: .post, body: body)
    }

    func testHttpPutRequest() {
        let url = rootURL.appendingPathComponent("posts/1")
        let body = jsonData(with: ["id": 1, "title": "test", "body": "put", "userId": 1] as [String : Any])

        performTestDataRequest(url: url, method: .put, body: body)
    }

    func testHttpPatchRequest() {
        let url = rootURL.appendingPathComponent("posts/1")
        let body = jsonData(with: ["body": "patch"] as [String : Any])

        performTestDataRequest(url: url, method: .patch, body: body)
    }

    func testHttpDeleteRequest() {
        let url = rootURL.appendingPathComponent("posts/1")

        performTestDataRequest(url: url, method: .delete)
    }
}


extension RequestServiceTests {

    ///Prepare JSON Data object
    func jsonData(with dictionary: [String : Any]) -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            XCTAssertNil(error, "Parsing to JSON failed: \(error.localizedDescription)")
            return Data()
        }
    }

    ///Perform test of request with given parameters
    func performTestDataRequest(url: URL, method: HttpMethod, body: Data? = nil) {
        let responseExpectation = expectation(description: "ExpectatResponseAction")

        var successPerformed = false
        let success = ResponseAction.success {response in
            if let code = response?.statusCode {
                print("--------------------")
                print("\(method.rawValue) request to URL \(url) finished with status code \(code).")
                print("--------------------")
            }
            successPerformed = true
            responseExpectation.fulfill()
        }

        var failurePerformed = false
        var responseError: Error?
        let failure = ResponseAction.failure {error in
            failurePerformed = true
            responseError = error
            responseExpectation.fulfill()
        }

        let request = HttpDataRequest(url: url, method: method, body: body, onSuccess: success, onFailure: failure)
        requestService.sendHTTPRequest(request)

        self.waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "\(method.rawValue) request test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(failurePerformed, "\(method.rawValue) request finished with failure: \(responseError?.localizedDescription)")
            XCTAssertTrue(successPerformed)
        }
    }
}
