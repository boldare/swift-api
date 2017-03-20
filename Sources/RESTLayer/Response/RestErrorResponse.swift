//
//  RestErrorResponse.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 06.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct RestErrorResponse {

    ///Error object describing problem.
    public let error: Error

    ///Data object describing cause of error sent by the server.
    public let body: Data?

    ///Headers containing detailed informations sent by the server.
    public let aditionalInfo: [RestResponseHeader]?

    ///Creates error response using only *Error*. Should be used in case of internal failure.
    init(error: Error) {
        self.error = error
        self.body = nil
        self.aditionalInfo = nil
    }

    ///Creates error response using all fields. Should be used in case of server side error.
    init(error: Error, body: Data?, aditionalInfo: [String : String]?) {
        self.error = error
        self.body = body
        self.aditionalInfo = RestResponseHeader.list(with: aditionalInfo)
    }
}
