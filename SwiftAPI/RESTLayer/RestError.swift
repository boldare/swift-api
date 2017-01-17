//
//  RestError.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 17.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

struct RestError {

    private static let restDomain = "RestServiceErrorDomain"

    ///Error called when service not receive response.
    static var noResponse: Error {
        return NSError(domain: restDomain, code: 600, userInfo: ["description" : "Rest service did not receive response."])
    }
}
