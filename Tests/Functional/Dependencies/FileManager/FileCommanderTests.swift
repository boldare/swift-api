//
//  FileCommanderTests.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 19.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import XCTest
@testable import SwiftAPI

class FileCommanderTests: XCTestCase {

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    fileprivate var imageURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "testImage", withExtension: "png")!
    }

    var exampleDestination: URL {
        return documentsUrl.appendingPathComponent("file.jpg")
    }


    func testCoppyFileWithSuccess() {
        let commander = FileCommander()
        let source = imageURL
        let destination = exampleDestination

        let error = commander.copyFile(from: source, to: destination)

        XCTAssertNil(error)
    }
    
    func testCoppyFileWithError() {
        let commander = FileCommander()
        let destination = exampleDestination

        let error = commander.copyFile(from: destination, to: destination)

        XCTAssertNotNil(error)
    }
    
}
