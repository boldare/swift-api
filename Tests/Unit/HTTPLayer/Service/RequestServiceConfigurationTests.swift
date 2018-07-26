//
//  RequestServiceConfigurationTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 19.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RequestServiceConfigurationTests: XCTestCase {
    
    func testForegroundConfiguration() {
        let config = RequestService.Configuration.foreground
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertNil(sessionConfig.identifier)
    }

    func testEphemeralConfiguration() {
        let config = RequestService.Configuration.ephemeral
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertNil(sessionConfig.identifier)
    }
    
    func testBackgroundConfiguration() {
        let config = RequestService.Configuration.background
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertNotNil(sessionConfig.identifier)
    }

    func testCustomConfiguration() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertEqual(sessionConfiguration, sessionConfig)
    }

    func testAllowsCellularAccess() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.allowsCellularAccess = false

        XCTAssertEqual(sessionConfiguration.allowsCellularAccess, config.allowsCellularAccess)
    }

    func testTimeoutForRequest() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.timeoutForRequest = 9999

        XCTAssertEqual(sessionConfiguration.timeoutIntervalForRequest, config.timeoutForRequest)
    }

    func testTimeoutForResource() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.timeoutForResource = 7777

        XCTAssertEqual(sessionConfiguration.timeoutIntervalForResource, config.timeoutForResource)
    }

    func testMaximumConnectionsPerHost() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.maximumConnectionsPerHost = 1234

        XCTAssertEqual(sessionConfiguration.httpMaximumConnectionsPerHost, config.maximumConnectionsPerHost)
    }

    func testCachePolicy() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        XCTAssertEqual(sessionConfiguration.requestCachePolicy, config.cachePolicy)
    }

    func testShouldSetCookies() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.shouldSetCookies = false

        XCTAssertEqual(sessionConfiguration.httpShouldSetCookies, config.shouldSetCookies)
    }

    func testCookieAcceptPolicy() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.cookieAcceptPolicy = .onlyFromMainDocumentDomain

        XCTAssertEqual(sessionConfiguration.httpCookieAcceptPolicy, config.cookieAcceptPolicy)
    }

    func testCookieStorage() {
        let sessionConfiguration = URLSessionConfiguration.default
        let config = RequestService.Configuration.custom(with: sessionConfiguration)
        config.cookieStorage = HTTPCookieStorage.shared

        XCTAssertEqual(sessionConfiguration.httpCookieStorage, config.cookieStorage)
    }
}
