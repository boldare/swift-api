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

    fileprivate var rootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    fileprivate var smallFileUrl: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
    }

    fileprivate var bigFileUrl: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg")!
    }

    fileprivate var localImageURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
    }

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    var requestService: RequestService!

    override func setUp() {
        super.setUp()

        requestService = RequestService(fileManager: DefaultFileManager())
    }

    override func tearDown() {
        requestService = nil
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
        let resourceUrl = localImageURL

        performTestUploadRequest(url: url, method: .post, resourceUrl: resourceUrl)
    }

    func testHttpPutUploadRequest() {
        let url = rootURL.appendingPathComponent("put")
        let resourceUrl = localImageURL

        performTestUploadRequest(url: url, method: .put, resourceUrl: resourceUrl)
    }

    func testHttpPatchUploadRequest() {
        let url = rootURL.appendingPathComponent("patch")
        let resourceUrl = localImageURL

        performTestUploadRequest(url: url, method: .patch, resourceUrl: resourceUrl)
    }

    //MARK: DownloadRequest tests
    func testHttpDownloadRequest() {
        let fileUrl = smallFileUrl
        let destinationUrl = documentsUrl
        let responseExpectation = expectation(description: "Expect response from \(fileUrl)")

        var successPerformed = false
        let success = ResponseAction.success {response in
            if let code = response?.statusCode {
                print("--------------------")
                print("Downloading from URL \(fileUrl) finished with status code \(code).")
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

        let request = HttpDownloadRequest(url: fileUrl, destinationUrl: destinationUrl, onSuccess: success, onFailure: failure, useProgress: false)
        requestService.sendHTTPRequest(request, with: .foreground)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Download request test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(failurePerformed, "Download request finished with failure: \(responseError!.localizedDescription)")
            XCTAssertTrue(successPerformed)
        }
    }

    //MARK: Request managing tests
    func testHttpRequestCancel() {
        let fileUrl = smallFileUrl
        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")
        let responseExpectation = expectation(description: "Expect response from \(fileUrl)")

        var successPerformed = false
        let success = ResponseAction.success {response in
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

        let request = HttpDownloadRequest(url: fileUrl, destinationUrl: destinationUrl, onSuccess: success, onFailure: failure, useProgress: false)
        requestService.sendHTTPRequest(request, with: .foreground)
        requestService.cancel(request)

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Download request test failed with error: \(error!.localizedDescription)")
            XCTAssertTrue(failurePerformed)
            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
            XCTAssertFalse(successPerformed)
        }
    }

    func testHttpRequestCancelAll() {
        let fileUrl1 = bigFileUrl
        let fileUrl2 = bigFileUrl
        let destinationUrl = documentsUrl
        let responseExpectation = expectation(description: "Expect file")

        var successPerformed = false
        let success = ResponseAction.success {response in
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
        let request1 = HttpDownloadRequest(url: fileUrl1, destinationUrl: destinationUrl, useProgress: false)
        let request2 = HttpDownloadRequest(url: fileUrl2, destinationUrl: destinationUrl, onSuccess: success, onFailure: failure, useProgress: false)

        requestService.sendHTTPRequest(request1, with: .foreground)
        requestService.sendHTTPRequest(request2, with: .foreground)
        requestService.cancelAllRequests()

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Download request test failed with error: \(error!.localizedDescription)")
            XCTAssertTrue(failurePerformed)
            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
            XCTAssertFalse(successPerformed)
        }
    }

    func testSuspendAndResume() {
        let url = rootURL.appendingPathComponent("get")
        let method = HttpMethod.get
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

        let request = HttpDataRequest(url: url, method: method, onSuccess: success, onFailure: failure)
        requestService.sendHTTPRequest(request)
        requestService.suspend(request)
        requestService.resume(request)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "\(method.rawValue) request test failed with error: \(error!.localizedDescription)")
            XCTAssertFalse(failurePerformed, "\(method.rawValue) request finished with failure: \(responseError!.localizedDescription)")
            XCTAssertTrue(successPerformed)
        }
    }
}


extension RequestServiceTests {

    ///Prepare JSON Data object
    fileprivate func jsonData(with dictionary: [String : Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
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
        requestService.sendHTTPRequest(request, with: .foreground)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "\(method.rawValue) request test failed with error: \(error!.localizedDescription)", file: file, line: line)
            XCTAssertFalse(failurePerformed, "\(method.rawValue) request finished with failure: \(responseError!.localizedDescription)", file: file, line: line)
            XCTAssertTrue(successPerformed, file: file, line: line)
        }
    }
}
