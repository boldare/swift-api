//
//  ApiServiceConfiguration.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 05.06.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import Foundation

public extension ApiService {

    /**
     Enum for informing about RestService errors

     - foreground: Indicates sending request only when app is running.
     - background: Indicates sending request also when app is not running or when is terminated by system.
     - ephemeral: Indicates sending request only when app is running bu with no caches, cookies, or credentials.
     - custom: Creates custom configuration based on URLSessionConfiguration.
     */
    public enum Configuration {
        case foreground
        case background
        case ephemeral
        case custom(URLSessionConfiguration)
    }
}

extension ApiService.Configuration {

    internal var requestConfiguration: RequestService.Configuration {
        switch self {
        case .foreground:
            return .foreground
        case .background:
            return .background
        case .ephemeral:
            return .ephemeral
        case .custom(let configuration):
            return .custom(with: configuration)
        }
    }
}
