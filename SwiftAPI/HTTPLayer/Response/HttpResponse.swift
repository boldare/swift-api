//
//  HttpResponse.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 21.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

struct HttpResponse {

    ///The URL for the response.
    let url: URL?

    ///The expected length of the response’s content.
    let expectedContentLength: Int64

    ///The MIME type of the response.
    let mimeType: String?

    ///The name of the text encoding provided by the response’s originating source.
    let textEncodingName: String?


    ///The HTTP status code of the receiver.
    let statusCode: Int?

    ///A dictionary containing all the HTTP header fields of the receiver.
    let allHeaderFields: [AnyHashable : Any]?

    /**
     Optional constructor.

     - Parameter urlResponse: URLResponse object returned by URLSession.

     - Returns: When urlResponse is not nil, creates and initiates HttpResponse instance, otherwise nil.
     */
    init?(urlResponse: URLResponse?) {
        guard let urlResponse = urlResponse else {
            return nil
        }
        
        self.url = urlResponse.url
        self.expectedContentLength = urlResponse.expectedContentLength
        self.mimeType = urlResponse.mimeType
        self.textEncodingName = urlResponse.textEncodingName
        if let response = urlResponse as? HTTPURLResponse {
            self.statusCode = response.statusCode
            self.allHeaderFields = response.allHeaderFields
        } else {
            self.statusCode = nil
            self.allHeaderFields = nil
        }
    }
}
