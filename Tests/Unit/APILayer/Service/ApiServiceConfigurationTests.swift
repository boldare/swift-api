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
        let config1 = ApiService.Configuration.foreground.requestConfiguration
        let config2 = RequestService.Configuration.foreground

        XCTAssertEqual(config1, config2)
    }

    func testBackgroundConfiguration() {
        let config1 = ApiService.Configuration.background.requestConfiguration
        let config2 = RequestService.Configuration.background

        XCTAssertEqual(config1, config2)
    }

    func testEphemeralConfiguration() {
        let config1 = ApiService.Configuration.ephemeral.requestConfiguration
        let config2 = RequestService.Configuration.ephemeral

        XCTAssertEqual(config1.shouldSetCookies, config2.shouldSetCookies)
        XCTAssertEqual(config1.cookieAcceptPolicy, config2.cookieAcceptPolicy)
        XCTAssertEqual(config1.cachePolicy, config2.cachePolicy)
    }

    func testCustomConfiguration() {
        let sessionConfiguration = URLSessionConfiguration()
        let config = ApiService.Configuration.custom(sessionConfiguration).requestConfiguration

        XCTAssertEqual(config, RequestService.Configuration.custom(with: sessionConfiguration))
    }
}
