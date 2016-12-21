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
    

    init(baseUrl: URL, path: String? = nil, httpMethod: HttpMethod, httpBody: Data? = nil) {
        self.baseUrl = baseUrl
        self.path = path
        self.httpMethod = httpMethod
        self.httpBody = httpBody
    }
}
