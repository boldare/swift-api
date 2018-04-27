//
//  ApiHeader.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 27.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct ApiHeader {

    ///Header field name.
    public let name: String

    ///Header field value.
    public let value: String

    /**
     - Parameters:
       - name: String containing header field name.
       - value: String containing header field value.
     */
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    /**
     Creates Basic Auth header.

     - Parameters:
       - login: String which should be used as login while authorizaton.
       - password: String which should be used as password while authorizaton.

     - Returns: Ready to use Basic Auth header, or nil when credentials encoding went wrong.
     */
    @available(*, deprecated, message: "Use Authorization.basic(login:password:) enum instad.")
    public init?(login: String, password: String) {
        guard let credentials = "\(login):\(password)".data(using: .utf8)?.base64EncodedString(options: .init(rawValue: 0)) else {
            return nil
        }
        self.name = "Authorization"
        self.value = "Basic \(credentials)"
    }
}

extension ApiHeader {

    public enum Authorization {

        private static let name = "Authorization"

        /**
         Creates authorization header.

         - Parameters:
           - value: String value of authorizaton header.

         - Returns: Ready to use Authorization header with given value.
         */
        public static func with(_ value: String) -> ApiHeader {
            return ApiHeader(name: name, value: value)
        }

        /**
         Creates Basic Auth header.

         - Parameters:
           - login: String which should be used as login while authorizaton.
           - password: String which should be used as password while authorizaton.

         - Returns: Ready to use Basic Auth header, or nil when credentials encoding went wrong.
         */
        public static func basic(login: String, password: String) -> ApiHeader? {
            guard let credentials = "\(login):\(password)".data(using: .utf8)?.base64EncodedString(options: .init(rawValue: 0)) else {
                return nil
            }
            return ApiHeader(name: name, value: "Basic \(credentials)")
        }
    }

    public enum ContentType {

        private static let name = "Content-Type"

        ///*Content-Type: text/plain* api header.
        public static var plainText: ApiHeader {
            return ApiHeader(name: name, value: "text/plain")
        }

        ///*Content-Type: application/json* api header.
        public static var json: ApiHeader {
            return ApiHeader(name: name, value: "application/json")
        }

        ///*Content-Type: application/x-www-form-urlencoded* api header.
        public static var urlEncoded: ApiHeader {
            return ApiHeader(name: name, value: "application/x-www-form-urlencoded")
        }

        /**
         - Parameters:
           - boundary: Custom boundary to be used in header.

         - Returns: *Content-Type: multipart/form-data* header with given boundary.
         */
        public static func multipart(with boundary: String) -> ApiHeader {
            return ApiHeader(name: name, value: "multipart/form-data; boundary=\(boundary)")
        }
    }
}

extension ApiHeader: Hashable {

    public var hashValue: Int {
        return "\(name):\(value)".hashValue
    }

    public static func ==(lhs: ApiHeader, rhs: ApiHeader) -> Bool {
        return lhs.name == rhs.name &&
            lhs.value == rhs.value
    }
}

extension ApiHeader {

    ///Returns *HttpHeader* version of *ApiHeader*
    var httpHeader: HttpHeader {
        return HttpHeader(name: name, value: value)
    }
}
