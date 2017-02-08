//
//  RestFileResource.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 08.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public protocol RestFileResource {

    ///REST name of file resource. Resource should be named with URI.
    var name: String{get}

    ///URL of file on device. In case of uploading file URL should point to existing file, but in case of downloading, file will be saved to that location.
    var location: URL{get}
}
