//
//  HttpRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

class HttpRequest: Hashable {

    ///The URL of the receiver.
    let url: URL

    ///The HTTP request method of the receiver.
    let method: HttpMethod

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
    init(url: URL, method: HttpMethod, onSuccess: ResponseAction? = nil, onFailure: ResponseAction? = nil, useProgress: Bool = false) {
        self.url = url
        self.method = method
        self.successAction = onSuccess
        self.failureAction = onFailure
        if useProgress {
            self.progress = Progress(totalUnitCount: -1)
        }
    }

    ///URLRequest representation of current object.
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }

    //MARK: Hashable Protocol
    var hashValue: Int {
        return "\(url.hashValue),\(method.rawValue.hashValue)".hashValue
    }

    public static func ==(lhs: HttpRequest, rhs: HttpRequest) -> Bool {
        return lhs.equalTo(rhs)
    }

    /**
     Compares current object with given one.

     - Parameter rhs: value to compare with.

     - Returns: A Boolean value indicating whether two values are equal.
     */
    func equalTo(_ rhs: HttpRequest) -> Bool {
        return type(of: self) == type(of: rhs) &&
               url == rhs.url &&
               method.rawValue == rhs.method.rawValue &&
               progress == rhs.progress
    }
}
