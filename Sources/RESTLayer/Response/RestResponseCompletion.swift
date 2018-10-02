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
   - data: Decoded data returned from server if there were any.
   - error: Error which occurred while processing request or decoding response if there was any.
 */
public typealias RestResponseCompletionHandler<ResponseType: Decodable> = (_ data: ResponseType?, _ details: RestResponseDetails) -> ()

/**
 Closure called when api request is finished.
 - Parameters:
   - success: Flag indicates if request finished with success.
   - error: Error which occurred while processing request if there was any.
 */
public typealias RestSimpleResponseCompletionHandler = (_ success: Bool, _ details: RestResponseDetails) -> ()
