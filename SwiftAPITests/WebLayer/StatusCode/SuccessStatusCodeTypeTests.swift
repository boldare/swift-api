//
//  InfoStatusCodeTypeTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class SuccessStatusCodeTypeTests: XCTestCase {

    func testConstructor() {
        let code = SuccessStatusCodeType(222)

        XCTAssertEqual(code?.value, 222)
    }

    func testConstructorForLowestCode() {
        let code = SuccessStatusCodeType(200)

        XCTAssertNotNil(code)
    }

    func testConstructorForHighestCode() {
        let code = SuccessStatusCodeType(299)

        XCTAssertNotNil(code)
    }

    func testConstructorForToLowCode() {
        let code = SuccessStatusCodeType(199)

        XCTAssertNil(code)
    }

    func testConstructorForToHighCode() {
        let code = SuccessStatusCodeType(300)

        XCTAssertNil(code)
    }

    func testEqualityOfTwoEqualCodes() {
        let code1 = SuccessStatusCodeType(202)
        let code2 = SuccessStatusCodeType(202)

        XCTAssertTrue(code1 == code2)
    }

    func testEqualityOfTwoNotEqualCodes() {
        let code1 = SuccessStatusCodeType(201)
        let code2 = SuccessStatusCodeType(202)

        XCTAssertFalse(code1 == code2)
    }

    func testDescription() {
        for i in 200..<299 {
            let code = SuccessStatusCodeType(i)
            XCTAssertNotNil(code?.description)
        }
    }
}
