//
//  RestResponseHeader.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.10.2018.
//  Copyright © 2018 XSolve. All rights reserved.
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
}
