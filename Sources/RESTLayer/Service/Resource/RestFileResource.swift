//
//  RestFileResource.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 08.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public protocol RestFileResource: RestResource {

    ///URL of file on device. In case of uploading file URL should point to existing file, but in case of downloading, file will be saved to that location.
    var location: URL{get}

    /**
     Updates object with header fields sent by server.

     - Parameter aditionalInfo: Headers containing aditional info sent by server.

     - Returns: If received header fields are ok or you don't expect any particular headers returns nil otherwise returns *Error* object containing description of problem.
     */
    mutating func update(with aditionalInfo: [RestResponseHeader]? ) -> Error?
}
