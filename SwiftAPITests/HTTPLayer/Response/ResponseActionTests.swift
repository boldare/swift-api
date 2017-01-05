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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerformSuccessAction() {

        var performedSuccess = false
        let success = ResponseAction.success {(_) in
            performedSuccess = true
        }

        //Perforem succes with error parameter
        let error = NSError()
        success.perform(with: error)
        XCTAssertFalse(performedSuccess)

        //Perforem succes with success parameters
        success.perform(with: nil)
        XCTAssertTrue(performedSuccess)
    }

    func testPerformFailureAction() {

        var performedFailure = false
        let failure = ResponseAction.failure {(_) in
            performedFailure = true
        }

        //Perforem failure with success parameters
        failure.perform(with: nil)
        XCTAssertFalse(performedFailure)

        //Perforem failure with error parameter
        let error = NSError()
        failure.perform(with: error)
        XCTAssertTrue(performedFailure)
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
