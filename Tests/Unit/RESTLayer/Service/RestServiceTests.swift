//
//  RestServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 07.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RestServiceTests: XCTestCase {

    func testConstructor() {
        let url = URL(string: "https://www.google.com")!
        let path = "search"
        let service = RestService(baseUrl: url, apiPath: path, headerFields: nil, coderProvider: DefaultCoderProvider(), fileManager: DefaultFileManager())

        XCTAssertEqual(service.baseUrl, url)
        XCTAssertEqual(service.apiPath, path)
        XCTAssertNotNil(service.apiService)
    }
}
