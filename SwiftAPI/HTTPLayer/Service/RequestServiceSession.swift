//
//  WebserviceSession.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

/**
 Available session using while sending requests.

 - foreground: indicates sending request only when app is running.
 - background: indicates sending request also when app is not running or when is terminated by system.
 */
enum RequestServiceSession {
    case foreground
    case background
}

extension RequestServiceSession {

    ///URLSession object for current session
    var urlSession: URLSession {
        var config: URLSessionConfiguration
        switch self {
        case .foreground:
            config = URLSessionConfiguration.default
        case .background:
            var identifier: String
            if let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
                let version = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String {
                identifier = "\(name)-\(version)"
            } else {
                identifier = "SwiftAPIBackgroundSession"
            }
            config = URLSessionConfiguration.background(withIdentifier: identifier)
        }
        return URLSession(configuration: config)
    }
}
