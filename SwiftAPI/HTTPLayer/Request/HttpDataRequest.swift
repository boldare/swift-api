//
//  HttpDataRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class HttpDataRequest: HttpRequest {

    let body: Data?

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
