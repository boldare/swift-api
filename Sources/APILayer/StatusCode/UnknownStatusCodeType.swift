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

    let description: String

    init(_ value: Int) {
        self.value = value
        self.description = "Application internal error"
    }

    init(_ error: Error) {
        value = (error as NSError).code
        description = error.localizedDescription
    }
}

extension UnknownStatusCodeType: Equatable {

    public static func ==(lhs: UnknownStatusCodeType, rhs: UnknownStatusCodeType) -> Bool {
        return lhs.value == rhs.value
    }
}
