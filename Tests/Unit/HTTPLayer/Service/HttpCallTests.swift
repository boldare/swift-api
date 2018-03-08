//
//  HttpCallTests.swift
//  UnitTests iOS
//
//  Created by Marek Kojder on 08.03.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpCallTests: XCTestCase {

    var progressBlock: SessionServiceProgressHandler {
        return { (_, _) in }
    }

    var successBlock: SessionServiceSuccessHandler {
        return { (_) in }
    }

    var failureBlock: SessionServiceFailureHandler {
        return { (_) in }
    }

    func testProgressBlock() {
        let blockExpectation = expectation(description: "Expect progress block")
        var processed = Int64(0)
        var expectedToProcess = Int64(0)
        let progress: SessionServiceProgressHandler = { (totalBytesProcessed, totalBytesExpectedToProcess) in
            processed = totalBytesProcessed
            expectedToProcess = totalBytesExpectedToProcess
            blockExpectation.fulfill()
        }
        let call = HttpCall(progressBlock: progress, successBlock: successBlock, failureBlock: failureBlock)
        call.performFailure(with: nil)
        call.performSuccess(with: HttpResponse(body: Data()))
        call.performProgress(totalBytesProcessed: 100, totalBytesExpectedToProcess: 200)

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertEqual(processed, 100)
            XCTAssertEqual(expectedToProcess, 200)
        }
    }

    func testSuccessBlock() {
        let blockExpectation = expectation(description: "Expect success block")
        let testResponse = HttpResponse(body: Data())
        var receivedResponse: HttpResponse?
        let success: SessionServiceSuccessHandler = { (response) in
            receivedResponse = response
            blockExpectation.fulfill()
        }

        let call = HttpCall(progressBlock: progressBlock, successBlock: success, failureBlock: failureBlock)
        call.performFailure(with: nil)
        call.performProgress(totalBytesProcessed: 0, totalBytesExpectedToProcess: 0)
        call.performSuccess(with: testResponse)

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertNotNil(receivedResponse)
            XCTAssertEqual(receivedResponse?.url, testResponse.url)
            XCTAssertEqual(receivedResponse?.expectedContentLength, testResponse.expectedContentLength)
            XCTAssertEqual(receivedResponse?.body, testResponse.body)
        }
    }

    func testFailureBlock() {
        let blockExpectation = expectation(description: "Expect progress block")
        let testError = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        var receivedError: NSError?
        let failure: SessionServiceFailureHandler = { (error) in
            receivedError = error as NSError
            blockExpectation.fulfill()
        }

        let call = HttpCall(progressBlock: progressBlock, successBlock: successBlock, failureBlock: failure)
        call.performSuccess(with: HttpResponse(body: Data()))
        call.performProgress(totalBytesProcessed: 0, totalBytesExpectedToProcess: 0)
        call.performFailure(with: testError)

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Test failed with error: \(error!.localizedDescription)")
            XCTAssertEqual(receivedError, testError)
        }
    }

    func testUpdateWithData() {
        let call = HttpCall(progressBlock: progressBlock, successBlock: successBlock, failureBlock: failureBlock)
        let data = Data(capacity: 10)

        call.update(with: data)

        XCTAssertNotNil(call.response)
        XCTAssertEqual(call.response?.body, data)
    }

    func testUpdateWithUrl() {
        let call = HttpCall(progressBlock: progressBlock, successBlock: successBlock, failureBlock: failureBlock)
        let url1 = URL(string: "http://cocoapods.org/")!
        let url2 = URL(string: "http://cocoapods.org/pods/SwiftAPI")!
        call.update(with: URLResponse(url: url1, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
        call.update(with: url2)

        XCTAssertNotNil(call.response)
        XCTAssertEqual(call.response?.resourceUrl, url2)
    }
}
