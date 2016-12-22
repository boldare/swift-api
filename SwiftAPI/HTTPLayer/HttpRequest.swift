//
//  HttpRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

struct HttpRequest {

    let url: URL
    let method: HttpMethod

    let body: Data?
    
    var onSuccess: ResponseAction?
    var onFailure: ResponseAction?
    var onProgress: ResponseAction?

    init(url: URL, method: HttpMethod, body: Data? = nil) {
        self.url = url
        self.method = method
        self.body = body
    }
}

extension HttpRequest: Hashable {
    var hashValue: Int {
        get {
            var string = "\(url.hashValue),\(method.rawValue.hashValue)"
            if let body = body {
                string.append(",\(body.hashValue)")
            }
            return string.hashValue
        }
    }

    public static func ==(lhs: HttpRequest, rhs: HttpRequest) -> Bool {
        return lhs.url == rhs.url &&
               lhs.method.rawValue == rhs.method.rawValue &&
               lhs.body == rhs.body
    }
}

extension HttpRequest {

    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
