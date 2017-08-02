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
        let config = RequestServiceConfiguration.foreground
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertNil(sessionConfig.identifier)
    }

    func testEphemeralConfiguration() {
        let config = RequestServiceConfiguration.ephemeral
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertNil(sessionConfig.identifier)
    }
    
    func testBackgroundConfiguration() {
        let config = RequestServiceConfiguration.background
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertNotNil(sessionConfig.identifier)
    }

    func testCustomConfiguration() {
        let sessionConfiguration = URLSessionConfiguration()
        let config = RequestServiceConfiguration.custom(with: sessionConfiguration)
        let sessionConfig = config.urlSessionConfiguration

        XCTAssertEqual(sessionConfiguration, sessionConfig)
    }
}
