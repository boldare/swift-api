//
//  RestResponseCompletion.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 08.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

/**
 Closure called when api request is finished.
 - Parameters:
   - resource: Resource returned from server if there is any.
   - errorResponse: Error which occurred while processing request.
 */
public typealias RestDataResponseCompletionHandler = (_ resource: RestDataResource, _ errorResponse: RestErrorResponse?) -> ()

/**
 Closure called when file request is finished.
 - Parameters:
   - resource: Resource returned from server if there is any.
   - errorResponse: Error which occurred while processing request.
 */
public typealias RestFileResponseCompletionHandler = (_ resource: RestFileResource, _ errorResponse: RestErrorResponse?) -> ()
