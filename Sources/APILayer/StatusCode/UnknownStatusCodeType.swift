//
//  SuccessStatusCodeType.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct UnknownStatusCodeType: StatusCodeType {

    let value: Int

    var description: String {
        return "Application unknown error"
    }

    init(_ value: Int) {
        self.value = value
    }
}

extension UnknownStatusCodeType: Equatable {

    public static func ==(lhs: UnknownStatusCodeType, rhs: UnknownStatusCodeType) -> Bool {
        return lhs.value == rhs.value
    }
}
