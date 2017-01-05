//
//  HttpMethod.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

/**
 HTTP methods for RESTful services.

 - get: use it to read data but not change it,
 - post: use it to create new resource,
 - put: use it to update/replace data at known resource URI
 - patch: use it to update data, but request only needs to contain the changes to the resource, not the complete resource.
 - delete: to delete a resource identified by a URI.
 */
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension HttpMethod: Equatable {
    
    public static func ==(lhs: HttpMethod, rhs: HttpMethod) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
