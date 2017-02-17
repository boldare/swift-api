//
//  InfoStatusCodeType.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct InfoStatusCodeType: StatusCodeType {

    let value: Int

    var description: String {
        switch value {
        case 100:
            return "Continue"
        case 101:
            return "Switching Protocols"
        case 102:
            return "Processing"
        default:
            return "Unknown status code"
        }
    }

    init?(_ value: Int) {
        guard value >= 100, value <= 199 else {
            return nil
        }
        self.value = value
    }
}

extension InfoStatusCodeType: Equatable {

    public static func ==(lhs: InfoStatusCodeType, rhs: InfoStatusCodeType) -> Bool {
        return lhs.value == rhs.value
    }
}
