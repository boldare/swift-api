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
}
