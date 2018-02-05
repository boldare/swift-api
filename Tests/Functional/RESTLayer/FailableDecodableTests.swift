//
//  FailableDecodableTests.swift
//  UnitTests iOS
//
//  Created by Marek Kojder on 30.01.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

private struct TestArray: Codable {

    struct TestData: Codable {
        let value: String
    }

    enum CodingKeys: String, CodingKey {
        case array
    }

    let array: [TestData]
    let failedCount: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decoded = try container.decodeArray(of: TestData.self, forKey: .array)
        array = decoded.array
        failedCount = decoded.failedCount
    }
}

class FailableDecodableTests: XCTestCase {

    var correctData: Data {
        let json = "{ \"array\": [{\"value\": \"test1\"}, {\"notValue\": \"test2\"}, {\"value\": \"test3\"}] }"
        return json.data(using: .utf8)!
    }

    var incorrectData: Data {
        let json = "{ \"array\": [{\"notValue\": \"test1\"}, {\"notValue\": \"test2\"}, {\"notValue\": \"test3\"}] }"
        return json.data(using: .utf8)!
    }

    func testSuccessEncoding() {
        let data = correctData
        let coderProvider = DefaultCoderProvider()
        let value = try? coderProvider.decode(TestArray.self, from: data)

        XCTAssertNotNil(value)
        XCTAssertEqual(value?.array.count, 2)
        XCTAssertEqual(value?.failedCount, 1)
    }

    func testFailureEncoding() {
        let data = incorrectData
        let coderProvider = DefaultCoderProvider()
        var decodedValue: TestArray?
        var decodingError: Error?
        do {
            decodedValue = try coderProvider.decode(TestArray.self, from: data)
        } catch {
            decodingError = error
        }

        XCTAssertNil(decodedValue)
        XCTAssertNotNil(decodingError)
    }
}
