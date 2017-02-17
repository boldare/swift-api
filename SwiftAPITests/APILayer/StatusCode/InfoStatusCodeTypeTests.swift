//
//  InfoStatusCodeTypeTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class InfoStatusCodeTypeTests: XCTestCase {

    func testConstructor() {
        let code = InfoStatusCodeType(111)

        XCTAssertEqual(code?.value, 111)
    }

    func testConstructorForLowestCode() {
        let code = InfoStatusCodeType(100)

        XCTAssertNotNil(code)
    }

    func testConstructorForHighestCode() {
        let code = InfoStatusCodeType(199)

        XCTAssertNotNil(code)
    }

    func testConstructorForToLowCode() {
        let code = InfoStatusCodeType(99)

        XCTAssertNil(code)
    }

    func testConstructorForToHighCode() {
        let code = InfoStatusCodeType(200)

        XCTAssertNil(code)
    }

    func testEqualityOfEqualCodes() {
        let code1 = InfoStatusCodeType(102)
        let code2 = InfoStatusCodeType(102)

        XCTAssertTrue(code1 == code2)
    }

    func testEqualityOfNotEqualCodes() {
        let code1 = InfoStatusCodeType(101)
        let code2 = InfoStatusCodeType(102)

        XCTAssertFalse(code1 == code2)
    }

    func testDescription() {
        for i in 100..<199 {
            let code = InfoStatusCodeType(i)
            XCTAssertNotNil(code?.description)
        }
    }
}
