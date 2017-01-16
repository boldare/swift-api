//
//  HttpDataRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

class HttpDataRequest: HttpRequest {

    ///This data is sent as the message body of the request
    let body: Data?

    /**
     Creates and initializes a HttpDataRequest with the given parameters.

     - Parameters:
       - url: URL of the receiver,
       - method: HTTP request method of the receiver,
       - body: Data object which supposed to be a body of the request,
       - onSuccess: action which needs to be performed when response was received from server,
       - onFailure: action which needs to be performed, when request has failed,
       - useProgress: flag indicates if Progress object should be created.

     - Returns: An initialized a HttpDataRequest object.
     */
    init(url: URL, method: HttpMethod, body: Data? = nil, onSuccess: ResponseAction? = nil, onFailure: ResponseAction? = nil, useProgress: Bool = false) {
        self.body = body
        super.init(url: url, method: method, onSuccess: onSuccess, onFailure: onFailure, useProgress: useProgress)
    }

    override var urlRequest: URLRequest {
        var request = super.urlRequest
        request.httpBody = body
        return request
    }

    //MARK: Hashable Protocol
    override var hashValue: Int {
        var string = "\(super.hashValue)"
        if let body = body {
            string.append(",\(body.hashValue)")
        }
        return string.hashValue
    }

    override func equalTo(_ rhs: HttpRequest) -> Bool {
        guard let rhs = rhs as? HttpDataRequest else {
            return false
        }
        return super.equalTo(rhs) &&
               body == rhs.body
    }
}
