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
    var fileToDownload: URL!


    override func setUp() {
        super.setUp()

        rootURL = URL(string: "https://httpbin.org")!
        requestService = RequestService(fileManager: FileCommander())
        fileToDownload = URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
    }

    override func tearDown() {
        rootURL = nil
        requestService = nil
        fileToDownload = nil
        super.tearDown()
    }


    //MARK: - DataRequest tests
    func testHttpGetDataRequest() {
        let url = rootURL.appendingPathComponent("get")

        performTestDataRequest(url: url, method: .get)
    }

    func testHttpPostDataRequest() {
        let url = rootURL.appendingPathComponent("post")
        let body = jsonData(with: ["title": "test", "body": "post", "userId": 1] as [String : Any])

        performTestDataRequest(url: url, method: .post, body: body)
    }

    func testHttpPutDataRequest() {
        let url = rootURL.appendingPathComponent("put")
        let body = jsonData(with: ["id": 1, "title": "test", "body": "put", "userId": 1] as [String : Any])

        performTestDataRequest(url: url, method: .put, body: body)
    }

    func testHttpPatchDataRequest() {
        let url = rootURL.appendingPathComponent("patch")
        let body = jsonData(with: ["body": "patch"] as [String : Any])

        performTestDataRequest(url: url, method: .patch, body: body)
    }

    func testHttpDeleteDataRequest() {
        let url = rootURL.appendingPathComponent("delete")

        performTestDataRequest(url: url, method: .delete)
    }

    //MARK: UploadRequest tests
    func testHttpPostUploadRequest() {
        let url = rootURL.appendingPathComponent("post")
        let resourceUrl = imageURL

        performTestUploadRequest(url: url, method: .post, resourceUrl: resourceUrl)
    }

    func testHttpPutUploadRequest() {
        let url = rootURL.appendingPathComponent("put")
        let resourceUrl = imageURL

        performTestUploadRequest(url: url, method: .put, resourceUrl: resourceUrl)
    }

    func testHttpPatchUploadRequest() {
        let url = rootURL.appendingPathComponent("patch")
        let resourceUrl = imageURL

        performTestUploadRequest(url: url, method: .patch, resourceUrl: resourceUrl)
    }

    //MARK: DownloadRequest tests
    func testHttpDownloadRequest() {
        let url = fileToDownload!
        let responseExpectation = expectation(description: "Expect response from \(url)")
        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")

        var successPerformed = false
        let success = ResponseAction.success {response in
            if let code = response?.statusCode {
                print("--------------------")
                print("Downloading from URL \(url) finished with status code \(code).")
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

        let request = HttpDownloadRequest(url: url, destinationUrl: destinationUrl, onSuccess: success, onFailure: failure, useProgress: false)
        requestService.sendHTTPRequest(request, in: .foreground)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Download request test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(failurePerformed, "Download request finished with failure: \(responseError!.localizedDescription)")
            XCTAssertTrue(successPerformed)
        }
    }
}


extension RequestServiceTests {

    ///Prepare JSON Data object
    fileprivate func jsonData(with dictionary: [String : Any]) -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            XCTAssertNil(error, "Parsing to JSON failed: \(error.localizedDescription)")
            return Data()
        }
    }

    fileprivate var imageURL: URL {
        if let assetUrl = Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png") {
            return assetUrl
        } else {
            XCTFail("Resource for tests not available")
            return URL(fileURLWithPath: "")
        }
    }

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    ///Perform test of data request with given parameters
    fileprivate func performTestDataRequest(url: URL, method: HttpMethod, body: Data? = nil, file: StaticString = #file, line: UInt = #line) {
        let responseExpectation = expectation(description: "Expect response from \(url)")

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

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "\(method.rawValue) request test failed with error: \(error!.localizedDescription)", file: file, line: line)
            XCTAssertFalse(failurePerformed, "\(method.rawValue) request finished with failure: \(responseError!.localizedDescription)", file: file, line: line)
            XCTAssertTrue(successPerformed, file: file, line: line)
        }
    }

    ///Perform test of upload request with given parameters
    fileprivate func performTestUploadRequest(url: URL, method: HttpMethod, resourceUrl: URL, file: StaticString = #file, line: UInt = #line) {
        let responseExpectation = expectation(description: "Expect response from \(url)")

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

        let request = HttpUploadRequest(url: url, method: method, resourceUrl: resourceUrl, onSuccess: success, onFailure: failure, useProgress: false)
        requestService.sendHTTPRequest(request, in: .foreground)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "\(method.rawValue) request test failed with error: \(error!.localizedDescription)", file: file, line: line)
            XCTAssertFalse(failurePerformed, "\(method.rawValue) request finished with failure: \(responseError!.localizedDescription)", file: file, line: line)
            XCTAssertTrue(successPerformed, file: file, line: line)
        }
    }
}
