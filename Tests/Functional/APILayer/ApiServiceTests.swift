//
//  ApiServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 19.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ApiServiceTests: XCTestCase {
    
    fileprivate var rootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    fileprivate var smallFileUrl: URL {
        return URL(string:"https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
    }

    fileprivate var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApi")]
    }

    fileprivate var localImageURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
    }

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    ///Prepare JSON Data object
    fileprivate func jsonData(with dictionary: [String : Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    var apiService: ApiService!

    override func setUp() {
        super.setUp()

        apiService = ApiService(fileManager: DefaultFileManager())
    }

    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
}

extension ApiServiceTests {

    func testGet() {
        let url = rootURL.appendingPathComponent("get")
        let headers = exampleHeaders
        let responseExpectation = expectation(description: "Expect GET response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.getData(from: url, with: headers, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "GET request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPost() {
        let url = rootURL.appendingPathComponent("post")
        let headers = exampleHeaders
        let data = jsonData(with: ["title": "test", "body": "post"] as [String : Any])

        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.post(data: data, at: url, with: headers, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPut() {
        let url = rootURL.appendingPathComponent("put")
        let headers = exampleHeaders
        let data = jsonData(with: ["id": 1, "title": "test", "body": "put"] as [String : Any])

        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.put(data: data,at: url, with: headers, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatch() {
        let url = rootURL.appendingPathComponent("patch")
        let headers = exampleHeaders
        let data = jsonData(with: ["body": "patch"] as [String : Any])

        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.patch(data: data, at: url, with: headers, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testDelete() {
        let url = rootURL.appendingPathComponent("delete")
        let responseExpectation = expectation(description: "Expect DELETE response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.delete(at: url, completion: completion)

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "DELETE request failed with error: \(responseError!.localizedDescription)")
        }
    }

    //MARK: Uploading tests
    func testPostFile() {
        let resourceUrl = localImageURL
        let destinationUrl = rootURL.appendingPathComponent("post")
        let headers = exampleHeaders

        let responseExpectation = expectation(description: "Expect POST response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.postFile(from: resourceUrl, to: destinationUrl, with: headers, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "POST request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPutFile() {
        let resourceUrl = localImageURL
        let destinationUrl = rootURL.appendingPathComponent("put")
        let headers = exampleHeaders

        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.putFile(from: resourceUrl, to: destinationUrl, with: headers, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testPatchFile() {
        let resourceUrl = localImageURL
        let destinationUrl = rootURL.appendingPathComponent("patch")
        let headers = exampleHeaders

        let responseExpectation = expectation(description: "Expect PATCH response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.patchFile(from: resourceUrl, to: destinationUrl, with: headers, inBackground: false, useProgress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "PATCH request failed with error: \(responseError!.localizedDescription)")
        }
    }

    //MARK: Downloading tests
    func testDownloadFile() {
        let remoteResourceUrl = smallFileUrl
        let destinationUrl = documentsUrl
        let headers = exampleHeaders

        let responseExpectation = expectation(description: "Expect download response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        let request = apiService.downloadFile(from: remoteResourceUrl, to: destinationUrl, with: headers, inBackground: false, useProgress: true, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "Download request failed with error: \(responseError!.localizedDescription)")
            XCTAssertNotNil(request.uuid)
            XCTAssertNotNil(request.progress)
        }
    }

    //MARK: Methods with configuration tests
    func testUploadRequest() {
        let resourceUrl = localImageURL
        let destinationUrl = rootURL.appendingPathComponent("put")
        let headers = exampleHeaders

        let responseExpectation = expectation(description: "Expect PUT response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.uploadFile(from: resourceUrl, to: destinationUrl, with: .put, aditionalHeaders: headers, configuration: .ephemeral, progress: false, completion: completion)

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "Custom PUT request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testDownloadRequest() {
        let remoteResourceUrl = smallFileUrl
        let destinationUrl = documentsUrl
        let headers = exampleHeaders

        let responseExpectation = expectation(description: "Expect download response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        let request = apiService.downloadFile(from: remoteResourceUrl, to: destinationUrl, with: headers, configuration: .ephemeral, progress: false, completion: completion)
        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "Custom download request failed with error: \(responseError!.localizedDescription)")
            XCTAssertNotNil(request.uuid)
            XCTAssertNil(request.progress)
        }
    }

    //MARK: Request managing tests
    func testCancelRequest() {
        let remoteResourceUrl = smallFileUrl
        let destinationUrl = documentsUrl.appendingPathComponent("file.jpg")

        let responseExpectation = expectation(description: "Expect download response")
        var response: ApiResponse?
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            response = r
            responseError = e
            responseExpectation.fulfill()
        }
        let request = apiService.downloadFile(from: remoteResourceUrl, to: destinationUrl, inBackground: false, useProgress: false, completion: completion)
        request.cancel()

        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
            XCTAssertNil(response)
        }
    }

    func testSuspendAndResume() {
        let remoteResourceUrl = smallFileUrl
        let destinationUrl = documentsUrl

        let responseExpectation = expectation(description: "Expect download response")
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            if let response = r, let responseUrl = response.url {
                print("--------------------")
                print("Request to URL \(responseUrl) finished with status code \(response.statusCode.rawValue).")
                print("--------------------")
            }
            responseError = e
            responseExpectation.fulfill()
        }
        let request = apiService.downloadFile(from: remoteResourceUrl, to: destinationUrl, inBackground: false, useProgress: false, completion: completion)
        request.suspend()
        request.resume()

        waitForExpectations(timeout: 300) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNil(responseError, "Download request failed with error: \(responseError!.localizedDescription)")
        }
    }

    func testCancelAllRequests() {
        let remoteResourceUrl = smallFileUrl
        let destinationUrl1 = documentsUrl.appendingPathComponent("file1.jpg")
        let destinationUrl2 = documentsUrl.appendingPathComponent("file2.jpg")

        let responseExpectation = expectation(description: "Expect download response")
        var response: ApiResponse?
        var responseError: Error?
        let completion = { (r: ApiResponse?, e: Error?) in
            response = r
            responseError = e
            responseExpectation.fulfill()
        }
        _ = apiService.downloadFile(from: remoteResourceUrl, to: destinationUrl1, inBackground: false, useProgress: false)
        _ = apiService.downloadFile(from: remoteResourceUrl, to: destinationUrl2, inBackground: false, useProgress: false, completion: completion)
        apiService.cancelAllRequests()

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertEqual(responseError?.localizedDescription, "cancelled", "Resposne should finnish with cancel error!")
            XCTAssertNil(response)
        }
    }
}
