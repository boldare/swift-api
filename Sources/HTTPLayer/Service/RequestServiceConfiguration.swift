//
//  WebserviceSession.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

///Available session configurations using while sending requests.
struct RequestServiceConfiguration {

    ///Indicates sending request only when app is running.
    static var foreground: RequestServiceConfiguration {
        return RequestServiceConfiguration(urlSessionConfiguration: .default)
    }

    ///Indicates sending request also when app is not running or when is terminated by system.
    static var background: RequestServiceConfiguration {
        var identifier: String
        if let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
            let version = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String {
            identifier = "\(name)-\(version)"
        } else {
            identifier = "SwiftAPIBackgroundSession"
        }
        return RequestServiceConfiguration(urlSessionConfiguration: .background(withIdentifier: identifier))
    }

    ///*URLSessionConfiguration* object for current session.
    private(set) var urlSessionConfiguration: URLSessionConfiguration

    ///Initializer without parameters is not allowed for this struct.
    private init() {
        self.urlSessionConfiguration = .default
    }

    ///Initializing with configuration.
    private init(urlSessionConfiguration: URLSessionConfiguration) {
        self.urlSessionConfiguration = urlSessionConfiguration
    }

    ///Initializing with custom settings
    init(cellularAccess: Bool = true, requestTimeout: TimeInterval = 60, useCookies: Bool = true) {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = cellularAccess
        config.timeoutIntervalForRequest = requestTimeout
        config.httpShouldSetCookies = useCookies

        self.urlSessionConfiguration = config
    }
}

extension RequestServiceConfiguration: Hashable {

    public var hashValue: Int {
        return urlSessionConfiguration.hashValue
    }

    public static func ==(lhs: RequestServiceConfiguration, rhs: RequestServiceConfiguration) -> Bool {
        return lhs.urlSessionConfiguration == rhs.urlSessionConfiguration
    }
}
