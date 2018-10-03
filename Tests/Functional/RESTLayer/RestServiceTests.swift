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

    private var rootURL: String {
        return "https://httpbin.org/"
    }

    private var downloadRootURL: String {
        return "https://upload.wikimedia.org/"
    }

    private var uploadingFileURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
    }

    private var downloadedFileURL: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    private var exampleData: ExampleData {
        return ExampleData(url: URL(string: rootURL)!)
    }

    private var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApi")]
    }

    private var exampleAuthHeader: [ApiHeader] {
        return [ApiHeader.Authorization.basic(login: "admin", password: "admin1")!]
    }

    private func log(_ details: RestResponseDetails, for path: ResourcePath, and resource: Codable? = nil) {
        var message = "Request for resource \(path.rawValue)"
        if details.statusCode.isSuccess {
            message.append(" succeeded.")
        } else {
            message.append(" failed with error: \(details.statusCode.description).")
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
        var responseFailed = true
        let completion = { [weak self] (data: ExampleData?, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.get(type: type, from: path, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "GET request failed with error")
        }
    }

    func testParsingFailureGet() {
        let type = ExampleFailData.self
        let path = ExamplePath.get
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error? = nil
        let completion = { [weak self] (data: ExampleFailData?, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseError = details.error
            responseExpectation.fulfill()
        }
        do {
            try restService.get(type: type, from: path, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(responseError, "GET request should fail")
        }
    }

    func testNotFoundFailureGet() {
        let type = ExampleData.self
        let path = ExamplePath.notFound
        let responseExpectation = expectation(description: "Expect GET response")
        var responseFailed = true
        let completion = { [weak self] (data: ExampleData?, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.get(type: type, from: path, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertTrue(responseFailed, "GET request should fail")
        }
    }

    func testUrlFailureGet() {
        let service = RestService(baseUrl: "")
        let type = ExampleData.self
        let path = ExamplePath.none
        do {
            try service.get(type: type, from: path)
            XCTFail("Request should throw an exception")
        } catch {
            XCTAssertEqual(error.localizedDescription, RestService.Error.url.localizedDescription)
        }
    }

    func testSimplePost() {
        let value: ExampleData? = nil
        let path = ExamplePath.post
        let responseExpectation = expectation(description: "Expect POST response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.post(value, at: path, aditionalHeaders: exampleAuthHeader, useProgress: false, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "POST request failed with error")
        }
    }

    func testPost() {
        let value = exampleData
        let path = ExamplePath.post
        let responseExpectation = expectation(description: "Expect POST response")
        var responseFailed = true
        let completion = { [weak self] (data: ExampleData?, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.post(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "POST request failed with error")
        }
    }

    func testSimplePut() {
        let value: ExampleData? = nil
        let path = ExamplePath.put
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.put(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "PUT request failed with error")
        }
    }

    func testPut() {
        let value = exampleData
        let path = ExamplePath.put
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseFailed = true
        let completion = { [weak self] (data: ExampleData?, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.put(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "PUT request failed with error")
        }
    }

    func testSimplePatch() {
        let value: ExampleData? = nil
        let path = ExamplePath.patch
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.patch(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "PATCH request failed with error")
        }
    }

    func testPatch() {
        let value = exampleData
        let path = ExamplePath.patch
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseFailed = true
        let completion = { [weak self] (data: ExampleData?, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.patch(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "PATCH request failed with error")
        }
    }

    func testSimpleDelete() {
        let value: ExampleData? = nil
        let path = ExamplePath.delete
        let responseExpectation = expectation(description: "Expect DELETE response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.delete(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "DELETE request failed with error")
        }
    }

    func testDelete() {
        let value = exampleData
        let path = ExamplePath.delete
        let responseExpectation = expectation(description: "Expect DELETE response")
        var responseFailed = true
        let completion = { [weak self] (data: ExampleData?, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try restService.delete(value, at: path, aditionalHeaders: exampleAuthHeader, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "DELETE request failed with error")
        }
    }

    //MARK: File requests tests
    func testGetFile() {
        let path = ExamplePath.fileToDownload
        let location = downloadedFileURL
        let responseExpectation = expectation(description: "Expect GET response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try _ = downloadRestService.getFile(at: path, saveAt: location, inBackground: false, useProgress: false, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "GET request failed with error")
        }
    }

    func testWrongPathGetFile() {
        let path = ExamplePath.fileToDownload
        let location = downloadedFileURL
        let responseExpectation = expectation(description: "Expect GET response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try _ = restService.getFile(at: path, saveAt: location, inBackground: false, useProgress: false, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 60) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertTrue(responseFailed, "GET request should fail")
        }
    }

    func testPostFile() {
        let path = ExamplePath.post
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect POST response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try _ = restService.postFile(from: location, at: path, inBackground: false, useProgress: false, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "POST request failed with error")
        }
    }

    func testPutFile() {
        let path = ExamplePath.put
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect PUT response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try _ = restService.putFile(from: location, at: path, inBackground: false, useProgress: false, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "PUT request failed with error")
        }
    }

    func testPatchFile() {
        let path = ExamplePath.patch
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try _ = restService.patchFile(from: location, at: path, inBackground: false, useProgress: false, completion: completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(responseFailed, "PATCH request failed with error")
        }
    }

    func testCancelAllRequests() {
        let path1 = ExamplePath.put
        let path2 = ExamplePath.patch
        let path3 = ExamplePath.get
        let location = uploadingFileURL
        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseFailed = true
        let completion = { [weak self] (success: Bool, details: RestResponseDetails) in
            self?.log(details, for: path2)
            responseFailed = !details.statusCode.isSuccess
            responseExpectation.fulfill()
        }
        do {
            try _ = restService.putFile(from: location, at: path1, inBackground: false, useProgress: false)
            try _ = restService.patchFile(from: location, at: path2, inBackground: false, useProgress: false, completion: completion)
            try restService.get(type: ExampleData.self, from: path3)
        } catch {
            XCTFail(error.localizedDescription)
        }
        restService.cancelAllRequests()

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertTrue(responseFailed, "Request should fail")
        }
    }
}
