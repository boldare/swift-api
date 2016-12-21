//
//  HttpMethod.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case put
    case patch
    case delete
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get:
            return "GET"

        case .post:
            return "POST"

        case .put:
            return "PUT"

        case .patch:
            return "PATCH"

        case .delete:
            return "DELETE"
        }
    }
}
