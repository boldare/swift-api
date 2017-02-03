//
//  ApiError.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 17.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

struct ApiError {

    private static let apiDomain = "SwiftApiServiceErrorDomain"

    ///Error called when service did not received response.
    static var noResponse: Error {
        return NSError(domain: apiDomain, code: -10, userInfo: [NSLocalizedDescriptionKey : "Rest service did not receive response."])
    }
}
