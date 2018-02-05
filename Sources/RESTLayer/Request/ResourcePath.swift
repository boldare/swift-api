//
//  ResourcePath.swift
//  SwiftAPI iOS
//
//  Created by Marek Kojder on 30.01.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

/// A type that can be used as a path of the resource.
public protocol ResourcePath {

    ///The string to use as path of the resource.
    var rawValue: String { get }

    /**
     Creates a new instance from the given string.

     - Parameter rawValue: The string value of the desired key.

     If the string passed as `rawValue` does not correspond to any instance of this type, the result is `nil`.
     */
    init?(rawValue: String)
}
