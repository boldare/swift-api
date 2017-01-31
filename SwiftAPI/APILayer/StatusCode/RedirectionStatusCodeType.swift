//
//  SuccessStatusCodeType.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct RedirectionStatusCodeType: StatusCodeType {

    let value: Int

    var description: String {
        switch value {
        case 300:
            return "Multiple Choices"
        case 301:
            return "Moved Permanently"
        case 302:
            return "Found"
        case 303:
            return "See Other"
        case 304:
            return "Not Modified"
        case 305:
            return "Use Proxy"
        case 307:
            return "Temporary Redirect"
        case 308:
            return "Permanent Redirect"
        default:
            return "Unknown status code"
        }
    }

    init?(_ value: Int) {
        guard value >= 300, value <= 399 else {
            return nil
        }
        self.value = value
    }
}

extension RedirectionStatusCodeType: Equatable {

    public static func ==(lhs: RedirectionStatusCodeType, rhs: RedirectionStatusCodeType) -> Bool {
        return lhs.value == rhs.value
    }
}
