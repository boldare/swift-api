//
//  ResponseActionTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 05.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class ResponseActionTests: XCTestCase {

    func testPerformSuccessAction() {
        let actionExpectation = expectation(description: "SuccessAction")
        let success = ResponseAction.success {(_) in
            actionExpectation.fulfill()
        }

        //Perforem succes with error parameter. Action should not be called.
        let error = NSError()
        success.perform(with: error)

        //Perforem succes with success parameters. Action should be called.
        success.perform(with: nil)

        self.waitForExpectations(timeout: 2)
    }

    func testPerformFailureAction() {
        let actionExpectation = expectation(description: "FailureAction")
        let failure = ResponseAction.failure {(_) in
            actionExpectation.fulfill()
        }

        //Perforem failure with success parameters. Action should not be called.
        failure.perform(with: nil)

        //Perforem failure with error parameter. Action should be called.
        let error = NSError()
        failure.perform(with: error)

        self.waitForExpectations(timeout: 2)
    }

    func testIsEqualByType() {
        let success1 = ResponseAction.success {(_) in
            print("Success 1")
        }
        let success2 = ResponseAction.success {(_) in
            print("Success 2")
        }
        let failure1 = ResponseAction.failure {(_) in
            print("Failure 1")
        }
        let failure2 = ResponseAction.failure {(_) in
            print("Failure 2")
        }

        XCTAssertTrue(success1.isEqualByType(with: success2))
        XCTAssertTrue(success2.isEqualByType(with: success1))
        XCTAssertTrue(failure1.isEqualByType(with: failure2))
        XCTAssertTrue(failure2.isEqualByType(with: failure1))
        XCTAssertFalse(success1.isEqualByType(with: failure1))
        XCTAssertFalse(success2.isEqualByType(with: failure2))
    }
}
