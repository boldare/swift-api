//
//  RestServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 19.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RestServiceTests: XCTestCase {
    
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

    var restService: RestService!

    override func setUp() {
        super.setUp()

        restService = RestService(fileManager: FileCommander())
    }

    override func tearDown() {
        restService = nil
        super.tearDown()
    }

    func testGet() {
        let url = rootURL.appendingPathComponent("get")

        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.get(from: url, completionHandler: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPost() {
        let url = rootURL.appendingPathComponent("post")
        let data = jsonData(with: ["title": "test", "body": "post"] as [String : Any])

        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.post(data: data, at: url, completionHandler: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPut() {
        let url = rootURL.appendingPathComponent("put")
        let data = jsonData(with: ["id": 1, "title": "test", "body": "put"] as [String : Any])

        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.put(data: data, at: url, completionHandler: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatch() {
        let url = rootURL.appendingPathComponent("patch")
        let data = jsonData(with: ["body": "patch"] as [String : Any])

        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.patch(data: data, at: url, completionHandler: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testDelete() {
        let url = rootURL.appendingPathComponent("delete")

        let responseExpectation = expectation(description: "Expect DELETE response")
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.delete(at: url, completionHandler: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "DELETE request failed with error: \(responseError!.localizedDescription)")
        }
    }

    //MARK: Uploading tests
    func testPostFile() {
        let url = rootURL.appendingPathComponent("post")
        let resourceUrl = localImageURL

        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.postFile(from: resourceUrl, to: url, inBackground: false, useProgress: false, completionHandler: completion)

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
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.putFile(from: resourceUrl, to: url, inBackground: false, useProgress: false, completionHandler: completion)

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
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = restService.patchFile(from: resourceUrl, to: url, inBackground: false, useProgress: false, completionHandler: completion)

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
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        let request = restService.download(from: fileUrl, to: destinationUrl, inBackground: false, useProgress: true, completionHandler: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "Download request failed with error: \(responseError!.localizedDescription)")
            XCTAssertNotNil(request.progress)
        }
    }

    //MARK: Request managing tests
    func testCancelRequest() {
        let fileUrl = smallFileUrl
        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")

        let responseExpectation = expectation(description: "Expect download response")
        var response: RestResponse?
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            response = r
            responseError = e
            responseExpectation.fulfill()
        }
        let request = restService.download(from: fileUrl, to: destinationUrl, inBackground: false, useProgress: false, completionHandler: completion)
        request.cancel()

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
            XCTAssertNil(response)
        }
    }

    func testSuspendAndResume() {
        let fileUrl = smallFileUrl
        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")

        let responseExpectation = expectation(description: "Expect download response")
        var responseError: Error?
        let completion = { (r: RestResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        let request = restService.download(from: fileUrl, to: destinationUrl, inBackground: false, useProgress: false, completionHandler: completion)
        request.suspend()
        request.resume()

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "Download request failed with error: \(responseError!.localizedDescription)")
        }
    }
}

extension RestServiceTests {

    ///Prepare JSON Data object
    fileprivate func jsonData(with dictionary: [String : Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }
}
