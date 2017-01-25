//
//  InfoStatusCodeTypeTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class RedirectionStatusCodeTypeTests: XCTestCase {

    func testConstructor() {
        let code = RedirectionStatusCodeType(333)

        XCTAssertEqual(code?.value, 333)
    }

    func testConstructorForLowestCode() {
        let code = RedirectionStatusCodeType(300)

        XCTAssertNotNil(code)
    }

    func testConstructorForHighestCode() {
        let code = RedirectionStatusCodeType(399)

        XCTAssertNotNil(code)
    }

    func testConstructorForToLowCode() {
        let code = RedirectionStatusCodeType(299)

        XCTAssertNil(code)
    }

    func testConstructorForToHighCode() {
        let code = RedirectionStatusCodeType(400)

        XCTAssertNil(code)
    }

    func testEqualityOfTwoEqualCodes() {
        let code1 = RedirectionStatusCodeType(302)
        let code2 = RedirectionStatusCodeType(302)

        XCTAssertTrue(code1 == code2)
    }

    func testEqualityOfTwoNotEqualCodes() {
        let code1 = RedirectionStatusCodeType(301)
        let code2 = RedirectionStatusCodeType(302)

        XCTAssertFalse(code1 == code2)
    }

    func testDescription() {
        for i in 300..<399 {
            let code = RedirectionStatusCodeType(i)
            XCTAssertNotNil(code?.description)
        }
    }
}
