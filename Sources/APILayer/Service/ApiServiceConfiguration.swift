//
//  ApiServiceConfiguration.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 05.06.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import Foundation

public extension ApiService {

    public typealias CachePolicy = NSURLRequest.CachePolicy

    public typealias CookieAcceptPolicy = HTTPCookie.AcceptPolicy

    public typealias CookieStorage = HTTPCookieStorage

    ///Struct containing most common behaviors and policies for requests.
    public struct Configuration {

        let requestServiceConfiguration: RequestService.Configuration

        private init(configuration: RequestService.Configuration) {
            requestServiceConfiguration = configuration
        }
    }
}

public extension ApiService.Configuration {

    ///Indicates sending request only when app is running.
    static var foreground: ApiService.Configuration {
        return ApiService.Configuration(configuration: .foreground)
    }

    ///Indicates sending request only when app is running.
    static var ephemeral: ApiService.Configuration {
        return ApiService.Configuration(configuration: .ephemeral)
    }

    ///Indicates sending request also when app is not running or when is terminated by system.
    static var background: ApiService.Configuration {
        return ApiService.Configuration(configuration: .background)
    }

    ///Creates custom configuration based on URLSessionConfiguration.
    static func custom(with urlSessionConfiguration: URLSessionConfiguration) -> ApiService.Configuration {
        return ApiService.Configuration(configuration: .custom(with: urlSessionConfiguration))
    }
}

public extension ApiService.Configuration {

    ///A Boolean value that determines whether connections should be made over a cellular network. The default value is true.
    var allowsCellularAccess: Bool {
        get { return requestServiceConfiguration.allowsCellularAccess }
        set { requestServiceConfiguration.allowsCellularAccess = newValue }
    }

    ///The timeout interval to use when waiting for additional data. The default value is 60.
    var timeoutForRequest: TimeInterval {
        get { return requestServiceConfiguration.timeoutForRequest }
        set { requestServiceConfiguration.timeoutForRequest = newValue }
    }

    ///The maximum amount of time (in seconds) that a resource request should be allowed to take. The default value is 7 days.
    var timeoutForResource: TimeInterval {
        get { return requestServiceConfiguration.timeoutForResource }
        set { requestServiceConfiguration.timeoutForResource = newValue }
    }

    ///The maximum number of simultaneous connections to make to a given host. The default value is 6 in macOS, or 4 in iOS.
    var maximumConnectionsPerHost: Int {
        get { return requestServiceConfiguration.maximumConnectionsPerHost }
        set { requestServiceConfiguration.maximumConnectionsPerHost = newValue }
    }

    ///A predefined constant that determines when to return a response from the cache. The default value is *.useProtocolCachePolicy*.
    var cachePolicy: ApiService.CachePolicy {
        get { return requestServiceConfiguration.cachePolicy }
        set { requestServiceConfiguration.cachePolicy = newValue }
    }

    ///A Boolean value that determines whether requests should contain cookies from the cookie store. The default value is true.
    var shouldSetCookies: Bool {
        get { return requestServiceConfiguration.shouldSetCookies }
        set { requestServiceConfiguration.shouldSetCookies = newValue }
    }

    ///A policy constant that determines when cookies should be accepted. The default value is *.onlyFromMainDocumentDomain*.
    var cookieAcceptPolicy: ApiService.CookieAcceptPolicy {
        get { return requestServiceConfiguration.cookieAcceptPolicy }
        set { requestServiceConfiguration.cookieAcceptPolicy = newValue }
    }

    ///The cookie store for storing cookies within this session. For *foreground* and *background* sessions, the default value is the shared cookie storage object.
    var cookieStorage: ApiService.CookieStorage? {
        get { return requestServiceConfiguration.cookieStorage }
        set { requestServiceConfiguration.cookieStorage = newValue }
    }
}
