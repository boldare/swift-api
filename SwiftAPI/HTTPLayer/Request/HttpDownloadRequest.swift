//
//  HttpDownloadRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class HttpDownloadRequest: HttpRequest {

    ///Destination URL for downloading resource.
    let destinationUrl: URL

    /**
     Creates and initializes a HttpDownloadRequest with the given parameters.

     - Parameters:
     - url: URL of the receiver,
     - method: HTTP request method of the receiver,
     - destinationUrl: destination URL for downloading resource,
     - onSuccess: action which needs to be performed when response was received from server,
     - onFailure: action which needs to be performed, when request has failed,
     - useProgress: flag indicates if Progress object should be created.

     - Returns: An initialized a HttpDownloadRequest object.
     */
    init(url: URL, method: HttpMethod, destinationUrl: URL, onSuccess: ResponseAction? = nil, onFailure: ResponseAction? = nil, useProgress: Bool = true) {
        self.destinationUrl = destinationUrl
        super.init(url: url, method: method, onSuccess: onSuccess, onFailure: onFailure, useProgress: useProgress)
    }

    //MARK: Hashable Protocol
    override var hashValue: Int {
        return "\(super.hashValue),\(destinationUrl.hashValue)".hashValue
    }

    override func equalTo(_ rhs: HttpRequest) -> Bool {
        guard let rhs = rhs as? HttpDownloadRequest else {
            return false
        }
        return super.equalTo(rhs) &&
               destinationUrl == rhs.destinationUrl
    }
}
