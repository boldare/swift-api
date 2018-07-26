//
//  ApiServiceConfigurationTests.swift
//  UnitTests iOS
//
//  Created by Marek Kojder on 05.06.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ApiServiceConfigurationTests: XCTestCase {

    func testForegroundConfiguration() {
        let config1 = ApiService.Configuration.foreground.requestServiceConfiguration
        let config2 = RequestService.Configuration.foreground

        XCTAssertEqual(config1, config2)
    }

    func testSettingForegroundConfiguration() {
        checkAndChangeParameters(for: .foreground)
    }

    func testBackgroundConfiguration() {
        let config1 = ApiService.Configuration.background.requestServiceConfiguration
        let config2 = RequestService.Configuration.background

        XCTAssertEqual(config1, config2)
    }

    func testSettingBackgroundConfiguration() {
        checkAndChangeParameters(for: .background)
    }

    func testEphemeralConfiguration() {
        let config1 = ApiService.Configuration.ephemeral.requestServiceConfiguration
        let config2 = RequestService.Configuration.ephemeral

        XCTAssertEqual(config1.shouldSetCookies, config2.shouldSetCookies)
        XCTAssertEqual(config1.cookieAcceptPolicy, config2.cookieAcceptPolicy)
        XCTAssertEqual(config1.cachePolicy, config2.cachePolicy)
    }

    func testSettingEphemeralConfiguration() {
        checkAndChangeParameters(for: .ephemeral)
    }

    func testCustomConfiguration() {
        let sessionConfiguration = URLSessionConfiguration()
        let config = ApiService.Configuration.custom(with: sessionConfiguration).requestServiceConfiguration

        XCTAssertEqual(config, RequestService.Configuration.custom(with: sessionConfiguration))
    }

    func testSettingCustomConfiguration() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.allowsCellularAccess = true
        sessionConfiguration.timeoutIntervalForRequest = 1
        sessionConfiguration.timeoutIntervalForResource = 2
        sessionConfiguration.httpMaximumConnectionsPerHost = 10
        sessionConfiguration.requestCachePolicy = .returnCacheDataDontLoad
        sessionConfiguration.httpShouldSetCookies = true
        sessionConfiguration.httpCookieAcceptPolicy = .never
        sessionConfiguration.httpCookieStorage = HTTPCookieStorage.shared
        let config = ApiService.Configuration.custom(with: sessionConfiguration)

        checkAndChangeParameters(for: config)
    }
}

private extension ApiServiceConfigurationTests {

    func checkAndChangeParameters(for apiConfiguration: ApiService.Configuration, file: StaticString = #file, line: UInt = #line) {
        var apiConfig = apiConfiguration
        let requestConfig = apiConfiguration.requestServiceConfiguration

        XCTAssertEqual(apiConfig.allowsCellularAccess, requestConfig.allowsCellularAccess, file: file, line: line)
        XCTAssertEqual(apiConfig.timeoutForRequest, requestConfig.timeoutForRequest, file: file, line: line)
        XCTAssertEqual(apiConfig.timeoutForResource, requestConfig.timeoutForResource, file: file, line: line)
        XCTAssertEqual(apiConfig.maximumConnectionsPerHost, requestConfig.maximumConnectionsPerHost, file: file, line: line)
        XCTAssertEqual(apiConfig.cachePolicy, requestConfig.cachePolicy, file: file, line: line)
        XCTAssertEqual(apiConfig.shouldSetCookies, requestConfig.shouldSetCookies, file: file, line: line)
        XCTAssertEqual(apiConfig.cookieAcceptPolicy, requestConfig.cookieAcceptPolicy, file: file, line: line)
        XCTAssertEqual(apiConfig.cookieStorage, requestConfig.cookieStorage, file: file, line: line)

        apiConfig.allowsCellularAccess = false
        apiConfig.timeoutForRequest = 1234
        apiConfig.timeoutForResource = 4321
        apiConfig.maximumConnectionsPerHost = 1
        apiConfig.cachePolicy = .reloadIgnoringLocalCacheData
        apiConfig.shouldSetCookies = false
        apiConfig.cookieAcceptPolicy = .always
        apiConfig.cookieStorage = nil

        XCTAssertEqual(apiConfig.allowsCellularAccess, requestConfig.allowsCellularAccess, file: file, line: line)
        XCTAssertEqual(apiConfig.timeoutForRequest, requestConfig.timeoutForRequest, file: file, line: line)
        XCTAssertEqual(apiConfig.timeoutForResource, requestConfig.timeoutForResource, file: file, line: line)
        XCTAssertEqual(apiConfig.maximumConnectionsPerHost, requestConfig.maximumConnectionsPerHost, file: file, line: line)
        XCTAssertEqual(apiConfig.cachePolicy, requestConfig.cachePolicy, file: file, line: line)
        XCTAssertEqual(apiConfig.shouldSetCookies, requestConfig.shouldSetCookies, file: file, line: line)
        XCTAssertEqual(apiConfig.cookieAcceptPolicy, requestConfig.cookieAcceptPolicy, file: file, line: line)
        XCTAssertEqual(apiConfig.cookieStorage, requestConfig.cookieStorage, file: file, line: line)
    }
}
