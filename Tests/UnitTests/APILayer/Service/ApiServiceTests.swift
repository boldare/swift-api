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

    func testConstructor() {
        let service = ApiService(fileManager: FileCommander())

        XCTAssertNotNil(service)
    }
}
