//
//  InfoStatusCodeTypeTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 18.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class StatusCodeTests: XCTestCase {

    func testRawValue() {
        let code1 = StatusCode(100)
        let code2 = StatusCode(200)
        let code3 = StatusCode(300)
        let code4 = StatusCode(400)
        let code5 = StatusCode(500)
        let code6 = StatusCode(600)

        XCTAssertEqual(code1.rawValue, 100)
        XCTAssertEqual(code2.rawValue, 200)
        XCTAssertEqual(code3.rawValue, 300)
        XCTAssertEqual(code4.rawValue, 400)
        XCTAssertEqual(code5.rawValue, 500)
        XCTAssertEqual(code6.rawValue, 600)
    }

    func testIsEqualByType() {
        let code10 = StatusCode(100)
        let code11 = StatusCode(110)
        let code20 = StatusCode(200)
        let code21 = StatusCode(210)
        let code30 = StatusCode(300)
        let code31 = StatusCode(310)
        let code40 = StatusCode(400)
        let code41 = StatusCode(410)
        let code50 = StatusCode(500)
        let code51 = StatusCode(510)
        let code60 = StatusCode(0)
        let code61 = StatusCode(900)

        XCTAssertTrue(code10.isEqualByType(with: code11))
        XCTAssertTrue(code20.isEqualByType(with: code21))
        XCTAssertTrue(code30.isEqualByType(with: code31))
        XCTAssertTrue(code40.isEqualByType(with: code41))
        XCTAssertTrue(code50.isEqualByType(with: code51))
        XCTAssertTrue(code60.isEqualByType(with: code61))
    }

    func testIsNotEqualByType() {
        let code1 = StatusCode(100)
        let code2 = StatusCode(200)
        let code3 = StatusCode(300)
        let code4 = StatusCode(400)
        let code5 = StatusCode(500)
        let code6 = StatusCode(0)

        XCTAssertFalse(code1.isEqualByType(with: code2))
        XCTAssertFalse(code1.isEqualByType(with: code3))
        XCTAssertFalse(code1.isEqualByType(with: code4))
        XCTAssertFalse(code1.isEqualByType(with: code5))
        XCTAssertFalse(code1.isEqualByType(with: code6))
        XCTAssertFalse(code2.isEqualByType(with: code3))
        XCTAssertFalse(code2.isEqualByType(with: code4))
        XCTAssertFalse(code2.isEqualByType(with: code5))
        XCTAssertFalse(code2.isEqualByType(with: code6))
        XCTAssertFalse(code3.isEqualByType(with: code4))
        XCTAssertFalse(code3.isEqualByType(with: code5))
        XCTAssertFalse(code3.isEqualByType(with: code6))
        XCTAssertFalse(code4.isEqualByType(with: code5))
        XCTAssertFalse(code4.isEqualByType(with: code6))
        XCTAssertFalse(code5.isEqualByType(with: code6))
    }

    func testEqualityOfEqualCodes() {
        let code10 = StatusCode(100)
        let code11 = StatusCode(100)
        let code20 = StatusCode(200)
        let code21 = StatusCode(200)
        let code30 = StatusCode(300)
        let code31 = StatusCode(300)
        let code40 = StatusCode(400)
        let code41 = StatusCode(400)
        let code50 = StatusCode(500)
        let code51 = StatusCode(500)
        let code60 = StatusCode(0)
        let code61 = StatusCode(0)

        XCTAssertTrue(code10 == code11)
        XCTAssertTrue(code20 == code21)
        XCTAssertTrue(code30 == code31)
        XCTAssertTrue(code40 == code41)
        XCTAssertTrue(code50 == code51)
        XCTAssertTrue(code60 == code61)
    }

    func testEqualityOfNotEqualCodes() {
        let code10 = StatusCode(100)
        let code11 = StatusCode(110)
        let code20 = StatusCode(200)
        let code21 = StatusCode(210)
        let code30 = StatusCode(300)
        let code31 = StatusCode(310)
        let code40 = StatusCode(400)
        let code41 = StatusCode(410)
        let code50 = StatusCode(500)
        let code51 = StatusCode(510)
        let code60 = StatusCode(0)
        let code61 = StatusCode(900)

        XCTAssertFalse(code10 == code11)
        XCTAssertFalse(code20 == code21)
        XCTAssertFalse(code30 == code31)
        XCTAssertFalse(code40 == code41)
        XCTAssertFalse(code50 == code51)
        XCTAssertFalse(code60 == code61)
    }

    func testIsInternalErrorStatusCode() {
        let error1 = StatusCode.internalErrorStatusCode
        let error2 = StatusCode(400)
        let error3 = StatusCode(500)
        let error4 = StatusCode(600)

        XCTAssertTrue(error1.isInternalErrorStatusCode)
        XCTAssertFalse(error2.isInternalErrorStatusCode)
        XCTAssertFalse(error3.isInternalErrorStatusCode)
        XCTAssertFalse(error4.isInternalErrorStatusCode)
    }

    func testIsSuccessStatusCode() {
        let info = StatusCode(103)
        let success1 = StatusCode(200)
        let success2 = StatusCode(204)
        let redirection = StatusCode(304)
        let error1 = StatusCode(400)
        let error2 = StatusCode(500)
        let unknown = StatusCode(0)

        XCTAssertTrue(success1.isSuccessStatusCode)
        XCTAssertTrue(success2.isSuccessStatusCode)
        XCTAssertFalse(info.isSuccessStatusCode)
        XCTAssertFalse(redirection.isSuccessStatusCode)
        XCTAssertFalse(error1.isSuccessStatusCode)
        XCTAssertFalse(error2.isSuccessStatusCode)
        XCTAssertFalse(unknown.isSuccessStatusCode)
    }

    func testIsRedirectionStatusCode() {
        let info = StatusCode(103)
        let success = StatusCode(200)
        let redirection1 = StatusCode(300)
        let redirection2 = StatusCode(304)
        let error1 = StatusCode(400)
        let error2 = StatusCode(500)
        let unknown = StatusCode(0)

        XCTAssertTrue(redirection1.isRedirectionStatusCode)
        XCTAssertTrue(redirection2.isRedirectionStatusCode)
        XCTAssertFalse(info.isRedirectionStatusCode)
        XCTAssertFalse(success.isRedirectionStatusCode)
        XCTAssertFalse(error1.isRedirectionStatusCode)
        XCTAssertFalse(error2.isRedirectionStatusCode)
        XCTAssertFalse(unknown.isRedirectionStatusCode)
    }

    func testIsInfoStatusCode() {
        let info1 = StatusCode(100)
        let info2 = StatusCode(103)
        let success = StatusCode(200)
        let redirection = StatusCode(304)
        let error1 = StatusCode(400)
        let error2 = StatusCode(500)
        let unknown = StatusCode(0)

        XCTAssertTrue(info1.isInfoStatusCode)
        XCTAssertTrue(info2.isInfoStatusCode)
        XCTAssertFalse(success.isInfoStatusCode)
        XCTAssertFalse(redirection.isInfoStatusCode)
        XCTAssertFalse(error1.isInfoStatusCode)
        XCTAssertFalse(error2.isInfoStatusCode)
        XCTAssertFalse(unknown.isInfoStatusCode)
    }

    func testIsErrorStatusCode() {
        let info = StatusCode(103)
        let success = StatusCode(200)
        let redirection = StatusCode(304)
        let error1 = StatusCode(400)
        let error2 = StatusCode(404)
        let error3 = StatusCode(500)
        let error4 = StatusCode(510)
        let unknown1 = StatusCode(0)
        let unknown2 = StatusCode(600)

        XCTAssertTrue(error1.isErrorStatusCode)
        XCTAssertTrue(error2.isErrorStatusCode)
        XCTAssertTrue(error3.isErrorStatusCode)
        XCTAssertTrue(error4.isErrorStatusCode)
        XCTAssertTrue(unknown1.isErrorStatusCode)
        XCTAssertTrue(unknown2.isErrorStatusCode)
        XCTAssertFalse(info.isErrorStatusCode)
        XCTAssertFalse(success.isErrorStatusCode)
        XCTAssertFalse(redirection.isErrorStatusCode)
    }
}
