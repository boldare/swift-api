//
//  ApiError.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 17.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

struct ApiError {

    ///Domain of SwiftAPI errors.
    private static let apiDomain = "SwiftApiServiceErrorDomain"

    ///Creates NSError with given code and description.
    private static func errorWith(code: Int, description: String) -> Error {
        return NSError(domain: apiDomain, code: code, userInfo: [NSLocalizedDescriptionKey : description])
    }

    ///Error called when service did not received response.
    static var noResponse: Error {
        return errorWith(code: -10, description: "Rest service did not receive response.")
    }

    /**
     Creates Error representation of not success status code.

     - Parameter statusCode: StatusCode for which should be created Error.
     */
    static func error(for statusCode: StatusCode?) -> Error? {
        guard let statusCode = statusCode, !statusCode.isSuccess else {
            return nil
        }
        return errorWith(code: statusCode.rawValue * 10, description: statusCode.description)
    }
}
