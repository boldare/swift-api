//
//  RestDataResource.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public protocol RestDataResource: RestResource {
    
    ///Ready to send Data object representing resource. If resource must be sent in JSON format, then use JSON parsing if XML than use XML and so on.
    var data: Data?{get}

    /**
     Updates object with it's data representation sent by server.

     - Parameters:
     - data: Data representation of object sent by API server.
     - aditionalInfo: Headers containing aditional info sent by server.

     - Returns: Error if parsing or updating went wrong.

     Method should take into account format of data sending by server, if it's JSON, XML or other.
     */
    mutating func update(with data: Data?, aditionalInfo: [RestResponseHeader]? ) -> Error?
}
