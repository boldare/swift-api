//
//  RestServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 07.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//
import XCTest
@testable import SwiftAPI

fileprivate struct ExampleDataResource: RestDataResource {

    let name: String
    private(set) var title: String
    private let shouldFail: Bool

    var data: Data? {
        let dictionary = ["title" : title]
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    init(name: String, title: String = "", shouldFail: Bool = false) {
        self.name = name
        self.title = title
        self.shouldFail = shouldFail
    }

    mutating func update(with data: Data?, aditionalInfo: [RestResponseHeader]? ) -> Error? {
        let error = NSError(domain: "Tests", code: -8, userInfo: [NSLocalizedDescriptionKey : "Unexpected error!"])
        return shouldFail ? error : nil
    }
}

fileprivate struct ExampleFileResource: RestFileResource {

    private class Resources {
    }

    let name: String
    let location: URL
    private let shouldFail: Bool

    init(name: String, upload: Bool, shouldFail: Bool = false) {
        self.shouldFail = shouldFail
        if upload {
            self.name = name
            self.location = Bundle(for: ExampleFileResource.Resources.self).url(forResource: "testImage", withExtension: "png")!
        } else {
            self.name = "wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg"
            self.location = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true).appendingPathComponent("file.jpg")
        }
    }

    mutating func update(with aditionalInfo: [RestResponseHeader]? ) -> Error? {
        let error = NSError(domain: "Tests", code: -8, userInfo: [NSLocalizedDescriptionKey : "Unexpected error!"])
        return shouldFail ? error : nil
    }
}

class RestServiceTests: XCTestCase {

    private var rootURL: URL {
        return URL(string: "https://httpbin.org/")!
    }

    private var downloadRootURL: URL {
        return URL(string: "https://upload.wikimedia.org/")!
    }

    private var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApi")]
    }

    fileprivate var exampleAuthHeader: [ApiHeader] {
        return [ApiHeader(login: "admin", password: "admin1")!]
    }

    fileprivate func log(response: RestErrorResponse?, for resourceNamed: String) {
        var message = "Request for resource \(resourceNamed)"
        if let errorResponse = response {
            message.append(" failed with error: \(errorResponse.error.localizedDescription).")
        } else {
            message.append(" succeeded.")
        }
        print("--------------------")
        print(message)
        print("--------------------")
    }

    var restService: RestService!
    var downloadRestService: RestService!

    override func setUp() {
        super.setUp()

        restService = RestService(baseUrl: rootURL, apiPath: "", headerFields: exampleHeaders, fileManager: FileCommander())
        downloadRestService = RestService(baseUrl: downloadRootURL, apiPath: "", headerFields: nil, fileManager: FileCommander())
    }

    override func tearDown() {
        restService = nil
        downloadRestService = nil
        super.tearDown()
    }
}


extension RestServiceTests {

    //MARK: Simple requests tests
    func testGet() {
        let resource = ExampleDataResource(name: "get")
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.get(resource: resource, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testParsingFailureGet() {
        let resource = ExampleDataResource(name: "get", shouldFail: true)
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.get(resource: resource, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testNotFoundFailureGet() {
        let resource = ExampleDataResource(name: "notFound")
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.get(resource: resource, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testPost() {
        let resource = ExampleDataResource(name: "post")
        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.post(resource: resource, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPut() {
        let resource = ExampleDataResource(name: "put")
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.put(resource: resource, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatch() {
        let resource = ExampleDataResource(name: "patch")
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.patch(resource: resource, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testDelete() {
        let resource = ExampleDataResource(name: "delete")
        let responseExpectation = expectation(description: "Expect DELETE response")
        var responseError: Error?
        let completion = { [weak self] (r: RestResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.delete(resource: resource, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "DELETE request failed with error: \(responseError!.localizedDescription)")
        }
    }

    //MARK: File requests tests
    func testGetFile() {
        let resource = ExampleFileResource(name: "", upload: false)
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (r: RestFileResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = downloadRestService.getFile(resource: resource, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testWrongPathGetFile() {
        let resource = ExampleFileResource(name: "", upload: false)
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (r: RestFileResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.getFile(resource: resource, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testFailureResponseGetFile() {
        let resource = ExampleFileResource(name: "", upload: false, shouldFail: true)
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (r: RestFileResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = downloadRestService.getFile(resource: resource, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testPostFile() {
        let resource = ExampleFileResource(name: "post", upload: true)
        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { [weak self] (r: RestFileResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.postFile(resource: resource, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPutFile() {
        let resource = ExampleFileResource(name: "put", upload: true)
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { [weak self] (r: RestFileResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.putFile(resource: resource, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatchFile() {
        let resource = ExampleFileResource(name: "patch", upload: true)
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (r: RestFileResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.patchFile(resource: resource, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testCancelAllRequests() {
        let resource1 = ExampleFileResource(name: "put", upload: true)
        let resource2 = ExampleFileResource(name: "patch", upload: true)
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (r: RestFileResource, e: RestErrorResponse?) in
            self?.log(response: e, for: r.name)
            responseError = e?.error
            responseExpectation.fulfill()
        }
        _ = restService.putFile(resource: resource1, inBackground: false, useProgress: false)
        _ = restService.patchFile(resource: resource2, inBackground: false, useProgress: false, completion: completion)
        restService.cancelAllRequests()

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
        }
    }
}
