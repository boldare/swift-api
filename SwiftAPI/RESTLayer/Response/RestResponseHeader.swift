//
//  RestResponseHeader.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 06.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct RestResponseHeader {

    ///Header field name.
    public let name: String

    ///Header field value.
    public let value: String

    /**
     - Parameters:
     - name: String containing header field name.
     - value: String containing header field value.
     */
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    /**
     Converts *[String : String]* dictionary to array of response headers.

     - Parameter headers: dictionary of headers

     - Returns: If *headers* is not nil, array of *RestResponseHeader* objects, otherwise nil.
     */
    static func responseHeaders(with headers: [String : String]?) -> [RestResponseHeader]? {
        guard let headers = headers else {
            return nil
        }
        var responseHeaders = [RestResponseHeader]()
        for (key, value) in headers {
            responseHeaders.append(RestResponseHeader(name: key, value: value))
        }
        return responseHeaders
    }
}
