//
//  InfoStatusCodeTypeTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ClientErrorStatusCodeTypeTests: XCTestCase {

    func testConstructor() {
        let code = ClientErrorStatusCodeType(444)

        XCTAssertEqual(code?.value, 444)
    }

    func testConstructorForLowestCode() {
        let code = ClientErrorStatusCodeType(400)

        XCTAssertNotNil(code)
    }

    func testConstructorForHighestCode() {
        let code = ClientErrorStatusCodeType(499)

        XCTAssertNotNil(code)
    }

    func testConstructorForToLowCode() {
        let code = ClientErrorStatusCodeType(399)

        XCTAssertNil(code)
    }

    func testConstructorForToHighCode() {
        let code = ClientErrorStatusCodeType(500)

        XCTAssertNil(code)
    }

    func testEqualityOfEqualCodes() {
        let code1 = ClientErrorStatusCodeType(402)
        let code2 = ClientErrorStatusCodeType(402)

        XCTAssertTrue(code1 == code2)
    }

    func testEqualityOfNotEqualCodes() {
        let code1 = ClientErrorStatusCodeType(401)
        let code2 = ClientErrorStatusCodeType(402)

        XCTAssertFalse(code1 == code2)
    }

    func testDescription() {
        for i in 400..<499 {
            let code = ClientErrorStatusCodeType(i)
            XCTAssertNotNil(code?.description)
        }
    }
}
