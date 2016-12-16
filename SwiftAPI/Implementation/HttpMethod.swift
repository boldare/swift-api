//
//  HttpMethod.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body)
    case put(Body)
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

        case .delete:
            return "DELETE"
        }
    }

    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .get:
            return .get

        case .post(let body):
            return .post(f(body))

        case .put(let body):
            return .put(f(body))

        case .delete:
            return .delete
        }
    }
}
