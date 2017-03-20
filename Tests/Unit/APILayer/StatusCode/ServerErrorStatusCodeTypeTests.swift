//
//  InfoStatusCodeTypeTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ServerErrorStatusCodeTypeTests: XCTestCase {

    func testConstructor() {
        let code = ServerErrorStatusCodeType(555)

        XCTAssertEqual(code?.value, 555)
    }

    func testConstructorForLowestCode() {
        let code = ServerErrorStatusCodeType(500)

        XCTAssertNotNil(code)
    }

    func testConstructorForHighestCode() {
        let code = ServerErrorStatusCodeType(599)

        XCTAssertNotNil(code)
    }

    func testConstructorForToLowCode() {
        let code = ServerErrorStatusCodeType(499)

        XCTAssertNil(code)
    }

    func testConstructorForToHighCode() {
        let code = ServerErrorStatusCodeType(600)

        XCTAssertNil(code)
    }

    func testEqualityOfEqualCodes() {
        let code1 = ServerErrorStatusCodeType(502)
        let code2 = ServerErrorStatusCodeType(502)

        XCTAssertTrue(code1 == code2)
    }

    func testEqualityOfNotEqualCodes() {
        let code1 = ServerErrorStatusCodeType(501)
        let code2 = ServerErrorStatusCodeType(502)

        XCTAssertFalse(code1 == code2)
    }

    func testDescription() {
        for i in 500..<599 {
            let code = ServerErrorStatusCodeType(i)
            XCTAssertNotNil(code?.description)
        }
    }
}
