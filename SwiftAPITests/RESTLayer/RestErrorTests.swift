//
//  RestErrorTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 19.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RestErrorTests: XCTestCase {
    
    func testNoResponse() {
        let error = RestError.noResponse

        XCTAssertFalse(error.localizedDescription.isEmpty)
        XCTAssertNotNil(error.localizedDescription.lowercased().range(of: "response"))
    }
}
