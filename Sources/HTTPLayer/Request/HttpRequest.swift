//
//  HttpRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

class HttpRequest {

    ///Unique id of request.
    let uuid: UUID

    ///The URL of the receiver.
    let url: URL

    ///The HTTP request method of the receiver.
    let method: HttpMethod

    ///Array of HTTP header fields
    let headerFields: [HttpHeader]?

    ///Action which needs to be performed when response was received from server.
    let successAction: ResponseAction?

    ///Action which needs to be performed, when request has failed.
    let failureAction: ResponseAction?

    ///Progress object which allows to follow request progress.
    var progress: Progress?

    /**
     Creates and initializes a HttpRequest with the given parameters.

     - Parameters:
       - url: URL of the receiver.
       - method: HTTP request method of the receiver.
       - onSuccess: action which needs to be performed when response was received from server.
       - onFailure: action which needs to be performed, when request has failed.
       - useProgress: flag indicates if Progress object should be created.

     - Returns: An initialized a HttpRequest object.
     */
    init(url: URL, method: HttpMethod, headers: [HttpHeader]? = nil, onSuccess: ResponseAction? = nil, onFailure: ResponseAction? = nil, useProgress: Bool = false) {
        self.uuid = UUID()
        self.url = url
        self.method = method
        self.headerFields = headers
        self.successAction = onSuccess
        self.failureAction = onFailure
        if useProgress {
            self.progress = Progress(totalUnitCount: -1)
        }
    }

    ///*URLRequest* representation of current object.
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers = headerFields {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        return request
    }
}

extension  HttpRequest: Hashable {

    final var hashValue: Int {
        return uuid.hashValue
    }

    /**
     Returns a Boolean value indicating whether two requests are equal.

     - Parameters:
       - rhs: A value to compare.
       - lhs: Another value to compare.

     -Important: Two requests are equal, when their UUID's are equal, it means that function will return *true* only when you are comparing the same instance of request or copy of that instance.
     */
    public static func ==(lhs: HttpRequest, rhs: HttpRequest) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
