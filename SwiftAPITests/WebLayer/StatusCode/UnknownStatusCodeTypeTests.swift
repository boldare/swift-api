//
//  InfoStatusCodeTypeTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class UnknownStatusCodeTypeTests: XCTestCase {

    func testConstructor() {
        let code = UnknownStatusCodeType(999)

        XCTAssertEqual(code.value, 999)
    }

    func testEqualityOfTwoEqualCodes() {
        let code1 = UnknownStatusCodeType(0)
        let code2 = UnknownStatusCodeType(0)

        XCTAssertTrue(code1 == code2)
    }

    func testEqualityOfTwoNotEqualCodes() {
        let code1 = UnknownStatusCodeType(-1)
        let code2 = UnknownStatusCodeType(1)

        XCTAssertFalse(code1 == code2)
    }

    func testDescription() {
        let code = UnknownStatusCodeType(0)
        XCTAssertNotNil(code.description)
    }
}
