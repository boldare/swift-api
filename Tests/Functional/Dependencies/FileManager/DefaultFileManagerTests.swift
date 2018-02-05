//
//  DefaultFileManagerTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 19.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class DefaultFileManagerTests: XCTestCase {

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    fileprivate var imageURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
    }

    var exampleDestination: URL {
        return documentsUrl
    }


    func testCoppyFileWithSuccess() {
        let manager = DefaultFileManager()
        let source = imageURL
        let destination = exampleDestination

        let error = manager.copyFile(from: source, to: destination)

        XCTAssertNil(error)
    }
    
    func testCoppyFileWithError() {
        let manager = DefaultFileManager()
        let destination = exampleDestination

        let error = manager.copyFile(from: destination, to: destination)

        XCTAssertNotNil(error)
    }
    
}
