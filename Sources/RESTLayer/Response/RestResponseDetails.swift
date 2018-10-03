//
//  RestResponseDetails.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.10.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import Foundation

public struct RestResponseDetails {

    ///Error object containing internal errors
    public internal(set) var error: Error?

    ///The status code of the receiver.
    public let statusCode: StatusCode

    ///Data object returned by receiver.
    public let rawBody: Data?

    ///A dictionary containing all the HTTP header fields of the receiver.
    public let responseHeaderFields: [RestResponseHeader]

    init(_ error: Error?) {
        self.error = error
        statusCode = StatusCode.internalError
        rawBody = nil
        responseHeaderFields = []
    }

    init(_ response: ApiResponse) {
        error = nil
        statusCode = response.statusCode
        rawBody = response.body
        responseHeaderFields = response.allHeaderFields?.map({ RestResponseHeader(name: $0.0, value: $0.1) }) ?? []
    }

    ///Prints to console pretty formatted JSON docoded from body.
    public func printPrettyBody() {
        guard let body = rawBody else {
            print("Body is nil.")
            return
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: body)
            print(NSString(data: try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), encoding: String.Encoding.utf8.rawValue) ?? "Body could not be serialized!")
        } catch {
            print(error.localizedDescription)
        }
    }
}
