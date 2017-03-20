//
//  RestResource.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 03.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public protocol RestResource {

    ///REST name of resource. Resource should be named with URI.
    var name: String{get}
}
