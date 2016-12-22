//
//  HttpRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

struct HttpRequest {

    let baseUrl: URL
    let httpMethod: HttpMethod

    var path: String?
    var httpBody: Data?

    var task: URLSessionTask?
    
    init(baseUrl: URL, path: String? = nil, httpMethod: HttpMethod, httpBody: Data? = nil) {
        self.baseUrl = baseUrl
        self.path = path
        self.httpMethod = httpMethod
        self.httpBody = httpBody
    }

    func cancel() {
        task?.cancel()
    }

    func suspend() {
        task?.suspend()
    }

    func resume() {
        task?.resume()
    }
}

extension HttpRequest: Hashable {
    var hashValue: Int {
        get {
            var string = "\(baseUrl.hashValue),\(httpMethod.method.hashValue)"
            if let path = path {
                string.append(",\(path.hashValue)")
            }
            if let body = httpBody {
                string.append(",\(body.hashValue)")
            }
            return string.hashValue
        }
    }

    public static func ==(lhs: HttpRequest, rhs: HttpRequest) -> Bool {
        return lhs.baseUrl == rhs.baseUrl &&
               lhs.path == rhs.path &&
               lhs.httpMethod.method == rhs.httpMethod.method &&
               lhs.httpBody == rhs.httpBody
    }
}

extension HttpRequest {

    var urlRequest: URLRequest {
        var url = baseUrl
        if let path = path {
            url.appendPathComponent(path)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        request.httpBody = httpBody
        return request
    }
}
