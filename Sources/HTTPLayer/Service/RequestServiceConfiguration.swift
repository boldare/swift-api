//
//  WebserviceSession.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 02.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

extension RequestService {

    ///Available session configurations using while sending requests.
    final class Configuration {

        ///*URLSessionConfiguration* object for current session.
        let urlSessionConfiguration: URLSessionConfiguration

        ///Initializing with configuration.
        private init(urlSessionConfiguration: URLSessionConfiguration) {
            self.urlSessionConfiguration = urlSessionConfiguration
        }
    }
}

extension RequestService.Configuration {

    ///Indicates sending request only when app is running.
    static var foreground: RequestService.Configuration {
        return RequestService.Configuration(urlSessionConfiguration: .default)
    }

    ///Indicates sending request only when app is running.
    static var ephemeral: RequestService.Configuration {
        return RequestService.Configuration(urlSessionConfiguration: .ephemeral)
    }

    ///Indicates sending request also when app is not running or when is terminated by system.
    static var background: RequestService.Configuration {
        var identifier: String
        if let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
            let version = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String {
            identifier = "\(name)-\(version)"
        } else {
            identifier = "SwiftAPIBackgroundSession"
        }
        return RequestService.Configuration(urlSessionConfiguration: .background(withIdentifier: identifier))
    }

    ///Creates custom configuration based on URLSessionConfiguration.
    static func custom(with urlSessionConfiguration: URLSessionConfiguration) -> RequestService.Configuration {
        return RequestService.Configuration(urlSessionConfiguration: urlSessionConfiguration)
    }
}

extension RequestService.Configuration {

    ///A Boolean value that determines whether connections should be made over a cellular network. The default value is true.
    var allowsCellularAccess: Bool {
        get { return urlSessionConfiguration.allowsCellularAccess }
        set { urlSessionConfiguration.allowsCellularAccess = newValue }
    }

    ///The timeout interval to use when waiting for additional data. The default value is 60.
    var timeoutForRequest: TimeInterval {
        get { return urlSessionConfiguration.timeoutIntervalForRequest }
        set { urlSessionConfiguration.timeoutIntervalForRequest = newValue }
    }

    ///The maximum amount of time (in seconds) that a resource request should be allowed to take. The default value is 7 days.
    var timeoutForResource: TimeInterval {
        get { return urlSessionConfiguration.timeoutIntervalForResource }
        set { urlSessionConfiguration.timeoutIntervalForResource = newValue }
    }

    ///The maximum number of simultaneous connections to make to a given host. The default value is 6 in macOS, or 4 in iOS.
    var maximumConnectionsPerHost: Int {
        get { return urlSessionConfiguration.httpMaximumConnectionsPerHost }
        set { urlSessionConfiguration.httpMaximumConnectionsPerHost = newValue }
    }

    ///A predefined constant that determines when to return a response from the cache. The default value is *.useProtocolCachePolicy*.
    var cachePolicy: NSURLRequest.CachePolicy {
        get { return urlSessionConfiguration.requestCachePolicy }
        set { urlSessionConfiguration.requestCachePolicy = newValue }
    }

    ///A Boolean value that determines whether requests should contain cookies from the cookie store. The default value is true.
    var shouldSetCookies: Bool {
        get { return urlSessionConfiguration.httpShouldSetCookies }
        set { urlSessionConfiguration.httpShouldSetCookies = newValue }
    }

    ///A policy constant that determines when cookies should be accepted. The default value is *.onlyFromMainDocumentDomain*.
    var cookieAcceptPolicy: HTTPCookie.AcceptPolicy {
        get { return urlSessionConfiguration.httpCookieAcceptPolicy }
        set { urlSessionConfiguration.httpCookieAcceptPolicy = newValue }
    }

    ///The cookie store for storing cookies within this session. For *foreground* and *background* sessions, the default value is the shared cookie storage object.
    var cookieStorage: HTTPCookieStorage? {
        get { return urlSessionConfiguration.httpCookieStorage }
        set { urlSessionConfiguration.httpCookieStorage = newValue }
    }
}

extension RequestService.Configuration: Hashable {

    public var hashValue: Int {
        return urlSessionConfiguration.hashValue
    }

    public static func ==(lhs: RequestService.Configuration, rhs: RequestService.Configuration) -> Bool {
        return lhs.urlSessionConfiguration == rhs.urlSessionConfiguration
    }
}
