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
    init(url: URL, method: HttpMethod, resourceUrl: URL, onSuccess: ResponseAction? = nil, onFailure: ResponseAction? = nil, useProgress: Bool = true) {
        self.resourceUrl = resourceUrl
        super.init(url: url, method: method, onSuccess: onSuccess, onFailure: onFailure, useProgress: useProgress)
    }

    //MARK: Hashable Protocol
    override var hashValue: Int {
        return "\(super.hashValue),\(resourceUrl.hashValue)".hashValue
    }

    override func equalTo(_ rhs: HttpRequest) -> Bool {
        guard let rhs = rhs as? HttpUploadRequest else {
            return false
        }
        return super.equalTo(rhs) &&
               resourceUrl == rhs.resourceUrl
    }
}
