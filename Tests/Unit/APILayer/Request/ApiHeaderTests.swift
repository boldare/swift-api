//
//  ApiHeaderTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ApiHeaderTests: XCTestCase {
    
    func testHashValue() {
        let header1 = ApiHeader(name: "Header1", value: "Value1")
        let header2 = ApiHeader(name: "Header2", value: "Value2")

        XCTAssertTrue(header1.hashValue == header1.hashValue)
        XCTAssertFalse(header1.hashValue == header2.hashValue)
    }

    func testEqualityOfEqualHeaders() {
        let header1 = ApiHeader(name: "Header1", value: "Value1")
        let header2 = ApiHeader(name: "Header1", value: "Value1")

        XCTAssertTrue(header1 == header2)
    }

    func testEqualityOfNotEqualHeaders() {
        let header1 = ApiHeader(name: "Header1", value: "Value1")
        let header2 = ApiHeader(name: "Header1", value: "Value2")

        XCTAssertFalse(header1 == header2)
    }

    func testHttpHeader() {
        let header = ApiHeader(name: "Header1", value: "Value1")
        let httpHeader = header.httpHeader

        XCTAssertTrue(header.name == httpHeader.name)
        XCTAssertTrue(header.value == httpHeader.value)
    }

    func testBasicAuthConstructorHeader() {
        let login = "admin"
        let password = "admin1"
        let header = ApiHeader(login: login, password: password)
        let credentials = "\(login):\(password)".data(using: .utf8)?.base64EncodedString(options: .init(rawValue: 0))

        XCTAssertEqual(header?.name, "Authorization")
        XCTAssertEqual(header?.value, "Basic \(credentials!)")
    }

    func testBasicAuthHeader() {
        let login = "admin"
        let password = "admin1"
        let header = ApiHeader.Authorization.basic(login: login, password: password)
        let credentials = "\(login):\(password)".data(using: .utf8)?.base64EncodedString(options: .init(rawValue: 0))

        XCTAssertEqual(header?.name, "Authorization")
        XCTAssertEqual(header?.value, "Basic \(credentials!)")
    }

    func testCustomAuthHeader() {
        let value = "32f45b55nynh6u6n7j6j786b47ub67jb67jb5"
        let header = ApiHeader.Authorization.with(value)

        XCTAssertEqual(header.name, "Authorization")
        XCTAssertEqual(header.value, value)
    }

    func testPlainTextHeader() {
        let header = ApiHeader.ContentType.plainText

        XCTAssertEqual(header.name, "Content-Type")
        XCTAssertEqual(header.value, "text/plain")
    }

    func testJsonHeader() {
        let header = ApiHeader.ContentType.json

        XCTAssertEqual(header.name, "Content-Type")
        XCTAssertEqual(header.value, "application/json")
    }

    func testUrlEncodedHeader() {
        let header = ApiHeader.ContentType.urlEncoded

        XCTAssertEqual(header.name, "Content-Type")
        XCTAssertEqual(header.value, "application/x-www-form-urlencoded")
    }

    func testMultipartHeader() {
        let boundary = "v867fvi82374nr347by57t0234tb2"
        let header = ApiHeader.ContentType.multipart(with: boundary)

        XCTAssertEqual(header.name, "Content-Type")
        XCTAssertEqual(header.value, "multipart/form-data; boundary=\(boundary)")
    }
}
