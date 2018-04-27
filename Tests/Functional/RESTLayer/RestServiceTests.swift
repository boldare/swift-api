//
//  RestServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 07.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//
import XCTest
@testable import SwiftAPI

struct ExampleData: Codable {
    let url: URL
}

struct ExampleFailData: Codable {
    let notExistingProperty: Int
}

enum ExamplePath: String, ResourcePath {
    case get
    case post
    case patch
    case put
    case delete
    case notFound

    case none = ""
    case fileToDownload = "commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg"
}

class RestServiceTests: XCTestCase {

    private var rootURL: URL {
        return URL(string: "https://httpbin.org/")!
    }

    private var downloadRootURL: URL {
        return URL(string: "https://upload.wikimedia.org/")!
    }

    private var uploadingFileURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
    }

    private var downloadedFileURL: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    private var exampleData: ExampleData {
        return ExampleData(url: rootURL)
    }

    private var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApi")]
    }

    private var exampleAuthHeader: [ApiHeader] {
        return [ApiHeader.Authorization.basic(login: "admin", password: "admin1")!]
    }

    private func log(_ error: Error?, for path: ResourcePath, and resource: Codable? = nil) {
        var message = "Request for resource \(path.rawValue)"
        if let error = error {
            message.append(" failed with error: \(error.localizedDescription).")
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

        restService = RestService(baseUrl: rootURL, apiPath: "", headerFields: exampleHeaders, coderProvider: DefaultCoderProvider(), fileManager: DefaultFileManager())
        downloadRestService = RestService(baseUrl: downloadRootURL, apiPath: "wikipedia/", headerFields: nil, coderProvider: DefaultCoderProvider(), fileManager: DefaultFileManager())
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
        let type = ExampleData.self
        let path = ExamplePath.get
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (data: ExampleData?, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.get(type: type, from: path, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testParsingFailureGet() {
        let type = ExampleFailData.self
        let path = ExamplePath.get
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (data: ExampleFailData?, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.get(type: type, from: path, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testNotFoundFailureGet() {
        let type = ExampleData.self
        let path = ExamplePath.notFound
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (data: ExampleData?, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.get(type: type, from: path, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testSimplePost() {
        let value: ExampleData? = nil
        let path = ExamplePath.post
        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.post(value, at: path, aditionalHeaders: exampleAuthHeader, useProgress: false, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPost() {
        let value = exampleData
        let path = ExamplePath.post
        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { [weak self] (data: ExampleData?, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.post(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testSimplePut() {
        let value: ExampleData? = nil
        let path = ExamplePath.put
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.put(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPut() {
        let value = exampleData
        let path = ExamplePath.put
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { [weak self] (data: ExampleData?, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.put(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testSimplePatch() {
        let value: ExampleData? = nil
        let path = ExamplePath.patch
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.patch(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatch() {
        let value = exampleData
        let path = ExamplePath.patch
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (data: ExampleData?, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.patch(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testSimpleDelete() {
        let value: ExampleData? = nil
        let path = ExamplePath.delete
        let responseExpectation = expectation(description: "Expect DELETE response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.delete(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "DELETE request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testDelete() {
        let value = exampleData
        let path = ExamplePath.delete
        let responseExpectation = expectation(description: "Expect DELETE response")
        var responseError: Error?
        let completion = { [weak self] (data: ExampleData?, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        restService.delete(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "DELETE request failed with error: \(responseError!.localizedDescription)")
        }
    }

    //MARK: File requests tests
    func testGetFile() {
        let path = ExamplePath.fileToDownload
        let location = downloadedFileURL
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        _ = downloadRestService.getFile(at: path, saveAt: location, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testWrongPathGetFile() {
        let path = ExamplePath.fileToDownload
        let location = downloadedFileURL
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        _ = restService.getFile(at: path, saveAt: location, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 60) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testPostFile() {
        let path = ExamplePath.post
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        _ = restService.postFile(from: location, at: path, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPutFile() {
        let path = ExamplePath.put
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        _ = restService.putFile(from: location, at: path, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatchFile() {
        let path = ExamplePath.patch
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path)
            responseError = error
            responseExpectation.fulfill()
        }
        _ = restService.patchFile(from: location, at: path, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testCancelAllRequests() {
        let path1 = ExamplePath.put
        let path2 = ExamplePath.patch
        let path3 = ExamplePath.get
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { [weak self] (success: Bool, error: Error?) in
            self?.log(error, for: path2)
            responseError = error
            responseExpectation.fulfill()
        }
        _ = restService.putFile(from: location, at: path1, inBackground: false, useProgress: false)
        _ = restService.patchFile(from: location, at: path2, inBackground: false, useProgress: false, completion: completion)
        restService.get(type: ExampleData.self, from: path3)
        restService.cancelAllRequests()

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
        }
    }
}
