//
//  HttpHeaderTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 24.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class HttpHeaderTests: XCTestCase {

    func testHashValue() {
        let header1 = HttpHeader(name: "Header1", value: "Value1")
        let header2 = HttpHeader(name: "Header2", value: "Value2")

        XCTAssertTrue(header1.hashValue == header1.hashValue)
        XCTAssertFalse(header1.hashValue == header2.hashValue)
    }

    func testEqualityOfEqualHeaders() {
        let header1 = HttpHeader(name: "Header1", value: "Value1")
        let header2 = HttpHeader(name: "Header1", value: "Value1")

        XCTAssertTrue(header1 == header2)
    }

    func testEqualityOfNotEqualHeaders() {
        let header1 = HttpHeader(name: "Header1", value: "Value1")
        let header2 = HttpHeader(name: "Header1", value: "Value2")

        XCTAssertFalse(header1 == header2)
    }
}
