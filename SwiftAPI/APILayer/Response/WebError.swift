//
//  WebError.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 17.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

struct WebError {

    private static let restDomain = "RestServiceErrorDomain"

    ///Error called when service not receive response.
    static var noResponse: Error {
        return NSError(domain: restDomain, code: -10, userInfo: [NSLocalizedDescriptionKey : "Rest service did not receive response."])
    }
}
