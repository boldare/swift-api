//
//  HttpUploadRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

class HttpUploadRequest: HttpRequest {

    ///The URL of the resource to upload.
    let resourceUrl: URL

    /**
     Creates and initializes a HttpUploadRequest with the given parameters.

     - Parameters:
       - url: URL of the receiver.
       - method: HTTP request method of the receiver.
       - resourceUrl: URL of the resource to upload.
       - onSuccess: action which needs to be performed when response was received from server.
       - onFailure: action which needs to be performed, when request has failed.
       - useProgress: flag indicates if Progress object should be created.

     - Returns: An initialized a HttpUploadRequest object.
     */
    init(url: URL, method: HttpMethod, resourceUrl: URL, headers: [HttpHeader]? = nil, onSuccess: ResponseAction? = nil, onFailure: ResponseAction? = nil, useProgress: Bool = true) {
        self.resourceUrl = resourceUrl
        super.init(url: url, method: method, headers: headers, onSuccess: onSuccess, onFailure: onFailure, useProgress: useProgress)
    }
}
