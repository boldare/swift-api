//
//  HttpResponse.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 21.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

class HttpResponse {

    ///The URL for the response.
    private(set) var url: URL?

    ///The expected length of the response’s content.
    private(set) var expectedContentLength: Int64

    ///The MIME type of the response.
    private(set) var mimeType: String?

    ///The name of the text encoding provided by the response’s originating source.
    private(set) var textEncodingName: String?

    ///The HTTP status code of the receiver.
    private(set) var statusCode: Int?

    ///A dictionary containing all the HTTP header fields of the receiver.
    private(set) var allHeaderFields: [String : String]?

    ///Data object for collecting multipart response body.
    private(set) var body: Data?

    ///File URL on disc of downloaded resource. In most cases is equal to *destinationUrl* of *HttpDownloadRequest* object related to HTTP response.
    private(set) var resourceUrl: URL?

    /**
     Creates object and sets its body data.

     - Parameter body: body Data object.
     */
    init(body: Data) {
        self.expectedContentLength = -1
        self.body = body
    }

    /**
     Creates object and sets its downloaded resource URL.

     - Parameter resourceUrl: URL of downloaded resource.
     */
    init(resourceUrl: URL) {
        self.expectedContentLength = -1
        self.resourceUrl = resourceUrl
    }

    /**
     Updates response with given resource URL.

     - Parameter resourceUrl: URL of downloaded resource.
     */
    func update(with resourceUrl: URL) {
        self.resourceUrl = resourceUrl
    }

    /**
     Creates object by initating values with given URLResponse object values.

     - Parameter urlResponse: URLResponse object returned by URLSession.
     */
    init(urlResponse: URLResponse) {
        self.url = urlResponse.url
        self.expectedContentLength = urlResponse.expectedContentLength
        self.mimeType = urlResponse.mimeType
        self.textEncodingName = urlResponse.textEncodingName
        if let response = urlResponse as? HTTPURLResponse {
            self.statusCode = response.statusCode
            self.allHeaderFields = response.allHeaderFields as? [String : String]
        } else {
            self.statusCode = nil
            self.allHeaderFields = nil
        }
    }

    /**
     Updates properties with properties of given URLResponse object.

     - Parameter urlResponse: URLResponse object returned by URLSession.
     */
    func update(with urlResponse: URLResponse) {
        url = urlResponse.url
        expectedContentLength = urlResponse.expectedContentLength
        mimeType = urlResponse.mimeType
        textEncodingName = urlResponse.textEncodingName
        if let response = urlResponse as? HTTPURLResponse {
            statusCode = response.statusCode
            allHeaderFields = response.allHeaderFields as? [String : String]
        } else {
            statusCode = nil
            allHeaderFields = nil
        }
    }

    /**
     Appends the content of Data object to response body.

     - Parameter data: data to append.
     */
    func appendBody(_ data: Data) {
        if body != nil {
            body?.append(data)
        } else {
            body = Data(data)
        }
    }
}
