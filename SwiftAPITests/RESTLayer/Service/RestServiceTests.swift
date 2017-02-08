//
//  RestServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 07.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

fileprivate class ExampleResource: RestResource {

    let name: String

    private(set) var title: String

    var dataRepresentation: Data? {
        let dictionary = ["title" : title]
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    init(name: String, title: String = "") {
        self.name = name
        self.title = title
    }

    func updateWith(responseData: Data?, aditionalInfo: [RestResponseHeader]? ) -> Error? {
        return nil
    }

}

class RestServiceTests: XCTestCase {

    private var rootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    private var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApi")]
    }

    fileprivate var exampleAuthHeader: [ApiHeader] {
        return [ApiHeader(login: "admin", password: "admin1")!]
    }

    fileprivate func log(response: RestErrorResponse?, for resource: RestResource) {
        var message = "Request for resource \(resource.name)"
        if let errorResponse = response {
            message.append(" failed with error: \(errorResponse.error.localizedDescription).")
        } else {
            message.append(" succeeded.")
        }
        print("--------------------")
        print(message)
        print("--------------------")
    }

//    fileprivate var smallFileUrl: URL {
//        return URL(string:"https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
//    }
//
//    fileprivate var localImageURL: URL {
//        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
//    }
//
//    fileprivate var documentsUrl: URL {
//        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
//    }
//
//    ///Prepare JSON Data object
//    fileprivate func jsonData(with dictionary: [String : Any]) -> Data {
//        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
//    }

    var restService: RestService!

    override func setUp() {
        super.setUp()

        restService = RestService(baseUrl: rootURL, apiPath: "", headerFields: exampleHeaders, fileManager: FileCommander())
    }

    override func tearDown() {
        restService = nil
        super.tearDown()
    }
}

extension RestServiceTests {

    func testGet() {
        let resource = ExampleResource(name: "get")
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.get(resource: resource, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPost() {
        let resource = ExampleResource(name: "post")
        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.post(resource: resource, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPut() {
        let resource = ExampleResource(name: "put")
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.put(resource: resource, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatch() {
        let resource = ExampleResource(name: "patch")
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.patch(resource: resource, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }
}
