//
//  ApiHeader.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 27.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct ApiHeader {

    ///Header field name.
    public let name: String

    ///Header field value.
    public let value: String

    /**
     - Parameters:
       - name: String containing header field name.
       - value: String containing header field value.
     */
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension ApiHeader: Hashable {

    public var hashValue: Int {
        return "\(name):\(value)".hashValue
    }

    public static func ==(lhs: ApiHeader, rhs: ApiHeader) -> Bool {
        return lhs.name == rhs.name &&
            lhs.value == rhs.value
    }
}

extension ApiHeader {

    ///Returns HttpHeader version of ApiHeader
    var httpHeader: HttpHeader {
        return HttpHeader(name: name, value: value)
    }

}
