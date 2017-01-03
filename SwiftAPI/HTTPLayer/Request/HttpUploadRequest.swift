//
//  HttpUploadRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class HttpUploadRequest: HttpRequest {

    let resourceUrl: URL

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
