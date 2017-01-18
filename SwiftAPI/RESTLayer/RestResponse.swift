//
//  RestResponse.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

struct RestResponse {

    ///The URL for the response.
    let url: URL?

    ///The status code of the receiver.
    let statusCode: StatusCode

    ///The expected length of the response’s content.
    let expectedContentLength: Int64

    ///The MIME type of the response.
    let mimeType: String?

    ///The name of the text encoding provided by the response’s originating source.
    let textEncodingName: String?

    ///A dictionary containing all the HTTP header fields of the receiver.
    let allHeaderFields: [AnyHashable : Any]?

    ///Data object for collecting multipart response body.
    let body: Data?

    ///File URL on disc of downloaded resource.
    let resourceUrl: URL?

    /**
     Creates object by initating values with given HttpResponse object values.

     - Parameter httpResponse: HttpResponse object returned by RequestService.
     */
    init?(_ httpResponse: HttpResponse?) {
        guard let response = httpResponse else {
            return nil
        }
        self.url = response.url
        if let code = response.statusCode {
            self.statusCode = StatusCode(code)
        } else {
            self.statusCode = StatusCode.internalErrorStatusCode
        }
        self.expectedContentLength = response.expectedContentLength
        self.mimeType = response.mimeType
        self.textEncodingName = response.textEncodingName
        self.allHeaderFields = response.allHeaderFields
        self.body = response.body
        self.resourceUrl = response.resourceUrl
    }
}
