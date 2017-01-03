//
//  HttpRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

class HttpRequest: Hashable {

    let url: URL
    let method: HttpMethod
    
    let successAction: ResponseAction?
    let failureAction: ResponseAction?

    var progress: Progress?

    init(url: URL, method: HttpMethod, onSuccess: ResponseAction? = nil, onFailure: ResponseAction? = nil, useProgress: Bool = false) {
        self.url = url
        self.method = method
        self.successAction = onSuccess
        self.failureAction = onFailure
        if useProgress {
            self.progress = Progress(totalUnitCount: -1)
        }
    }

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

    func equalTo(_ rhs: HttpRequest) -> Bool {
        return type(of: self) == type(of: rhs) &&
               url == rhs.url &&
               method.rawValue == rhs.method.rawValue &&
               progress == rhs.progress
    }
}
