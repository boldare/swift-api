//
//  RestResource.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 03.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public protocol RestResource {

    ///REST name of the resource. Resource should be named with URI.
    var name: String{get}

    ///Ready to send Data object representing resource. If resource must be sent in JSON format, then use JSON parsing if XML than use XML and so on.
    var dataRepresentation: Data?{get}

    /**
     Updates object with it's data representation sent by server.

     - Parameter responseData: Data representation of object sent by API server.
     
     - Returns: Error if parsing or updating went wrong.
     
     Method should take into account format of data sending by server, if it's JSON, XML or other.
     */
    mutating func updateWith(responseData: Data?, aditionalInfo: [RestResponseHeader]? ) -> Error?
}
