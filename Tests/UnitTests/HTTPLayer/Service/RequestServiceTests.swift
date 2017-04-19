//
//  RequestServiceTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 04.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RequestServiceTests: XCTestCase {

    func testConstructor() {
        let service = RequestService(fileManager: FileCommander())

        XCTAssertNotNil(service)
    }
}
