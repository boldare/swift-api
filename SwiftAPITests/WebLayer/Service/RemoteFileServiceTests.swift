//
//  RemoteFileServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 24.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RemoteFileServiceTests: XCTestCase {

    fileprivate var rootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    fileprivate var smallFileUrl: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
    }

    fileprivate var localImageURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
    }

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    var fileService: RemoteFileService!

    override func setUp() {
        super.setUp()

        let header = HttpHeader(name: "testHeader", value: "testHeaderValue")
        fileService = RemoteFileService(headers: [header], fileManager: FileCommander())
    }

    override func tearDown() {
        fileService = nil
        super.tearDown()
    }

    //MARK: Uploading tests
    func testPostFile() {
        let url = rootURL.appendingPathComponent("post")
        let resourceUrl = localImageURL

        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { (r: WebResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = fileService.postFile(from: resourceUrl, to: url, inBackground: false, useProgress: false, completionHandler: completion)

        waitForExpectations(timeout: 150) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPutFile() {
        let url = rootURL.appendingPathComponent("put")
        let resourceUrl = localImageURL

        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { (r: WebResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = fileService.putFile(from: resourceUrl, to: url, inBackground: false, useProgress: false, completionHandler: completion)

        waitForExpectations(timeout: 150) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatchFile() {
        let url = rootURL.appendingPathComponent("patch")
        let resourceUrl = localImageURL

        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { (r: WebResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = fileService.patchFile(from: resourceUrl, to: url, inBackground: false, useProgress: false, completionHandler: completion)

        waitForExpectations(timeout: 150) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    //MARK: Downloading tests
    func testDownloadFile() {
        let fileUrl = smallFileUrl
        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")

        let responseExpectation = expectation(description: "Expect download response")
        var responseError: Error?
        let completion = { (r: WebResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        let request = fileService.download(from: fileUrl, to: destinationUrl, inBackground: false, useProgress: true, completionHandler: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "Download request failed with error: \(responseError!.localizedDescription)")
            XCTAssertNotNil(request.progress)
        }
    }

//    //MARK: Request managing tests
//    func testCancelRequest() {
//        let fileUrl = smallFileUrl
//        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")
//
//        let responseExpectation = expectation(description: "Expect download response")
//        var response: WebResponse?
//        var responseError: Error?
//        let completion = { (r: WebResponse?, e: Error?) in
//            response = r
//            responseError = e
//            responseExpectation.fulfill()
//        }
//        let request = fileService.download(from: fileUrl, to: destinationUrl, inBackground: false, useProgress: false, completionHandler: completion)
//        request.cancel()
//
//        waitForExpectations(timeout: 30) { error in
//            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
//            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
//            XCTAssertNil(response)
//        }
//    }
//
//    func testSuspendAndResume() {
//        let fileUrl = smallFileUrl
//        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")
//
//        let responseExpectation = expectation(description: "Expect download response")
//        var responseError: Error?
//        let completion = { (r: WebResponse?, e: Error?) in
//            if let response = r, let responseUrl = response.url {
//                print("--------------------")
//                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
//                print("--------------------")
//            }
//            responseError = e
//            responseExpectation.fulfill()
//        }
//        let request = fileService.download(from: fileUrl, to: destinationUrl, inBackground: false, useProgress: false, completionHandler: completion)
//        request.suspend()
//        request.resume()
//
//        waitForExpectations(timeout: 300) { error in
//            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
//            XCTAssertNil(responseError, "Download request failed with error: \(responseError!.localizedDescription)")
//        }
//    }
}
