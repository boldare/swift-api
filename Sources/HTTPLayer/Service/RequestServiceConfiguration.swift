//
//  WebserviceSession.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

///Available session configurations using while sending requests.
public struct RequestServiceConfiguration {

    ///*URLSessionConfiguration* object for current session.
    internal private(set) var urlSessionConfiguration: URLSessionConfiguration

    ///Initializer without parameters is not allowed for this struct.
    private init() {
        self.urlSessionConfiguration = .default
    }

    ///Initializing with configuration.
    internal init(urlSessionConfiguration: URLSessionConfiguration) {
        self.urlSessionConfiguration = urlSessionConfiguration
    }
}

public extension RequestServiceConfiguration {

    ///Indicates sending request only when app is running.
    static var foreground: RequestServiceConfiguration {
        return RequestServiceConfiguration(urlSessionConfiguration: .default)
    }

    ///Indicates sending request only when app is running.
    static var ephemeral: RequestServiceConfiguration {
        return RequestServiceConfiguration(urlSessionConfiguration: .ephemeral)
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

    ///Creates custom configuration based on URLSessionConfiguration.
    static func custom(with urlSessionConfiguration: URLSessionConfiguration) -> RequestServiceConfiguration {
        return RequestServiceConfiguration(urlSessionConfiguration: urlSessionConfiguration)
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
