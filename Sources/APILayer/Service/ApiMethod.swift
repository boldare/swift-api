//
//  HttpMethod.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

/**
 ApiService dedicated HTTP methods.

 - get: use it to read data but not change it,
 - post: use it to create new resource,
 - put: use it to update/replace data at known resource URI
 - patch: use it to update data, but request only needs to contain the changes to the resource, not the complete resource.
 - delete: to delete a resource identified by a URI.
 */
public enum ApiMethod {
    case get
    case post
    case put
    case patch
    case delete
}

extension ApiMethod {

    ///Returns HttpMethod corresponding to current ApiMethod
    var httpMethod: HttpMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
}
