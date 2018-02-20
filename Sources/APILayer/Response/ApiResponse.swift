//
//  ApiResponse.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct ApiResponse {

    ///The URL for the response.
    public let url: URL?

    ///The status code of the receiver.
    public let statusCode: StatusCode

    ///The expected length of the response’s content.
    public let expectedContentLength: Int64

    ///The MIME type of the response.
    public let mimeType: String?

    ///The name of the text encoding provided by the response’s originating source.
    public let textEncodingName: String?

    ///A dictionary containing all the HTTP header fields of the receiver.
    public let allHeaderFields: [String : String]?

    ///Data object for collecting multipart response body.
    public let body: Data?

    ///File URL on disc of downloaded resource.
    public let resourceUrl: URL?

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
            self.statusCode = StatusCode.internalError
        }
        self.expectedContentLength = response.expectedContentLength
        self.mimeType = response.mimeType
        self.textEncodingName = response.textEncodingName
        self.allHeaderFields = response.allHeaderFields
        self.body = response.body
        self.resourceUrl = response.resourceUrl
    }

    ///Returns pretty printed JSON docoded from body.
    public var prettyPrintedBody: String? {
        guard let body = body else {
            debugPrint("Body is nil.")
            return nil
        }
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: body) as? [String: Any] else {
                debugPrint("Body could not be read as dictionary.")
                return nil
            }
            return String(data: try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), encoding: .utf8)
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
