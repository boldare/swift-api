//
//  StatusCode.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

/**
 Enum stores status code of HTTP response

 - info: stores status codes from 100 to 199,
 - success: stores status codes from 200 to 299,
 - redirection: stores status codes from 300 to 399,
 - clientError: stores status codes from 400 to 499,
 - serverError: stores status codes from 500 to 599,
 - unknown: stores every  other status codes, it should be used for internal library errors.
 */
public enum StatusCode {
    case info(InfoStatusCodeType)
    case success(SuccessStatusCodeType)
    case redirection(RedirectionStatusCodeType)
    case clientError(ClientErrorStatusCodeType)
    case serverError(ServerErrorStatusCodeType)
    case unknown(UnknownStatusCodeType)
}

extension StatusCode {

    ///Returns raw value of status code.
    public var rawValue: Int {
        switch self {
        case .info(let type):
            return type.value
        case .success(let type):
            return type.value
        case .redirection(let type):
            return type.value
        case .clientError(let type):
            return type.value
        case .serverError(let type):
            return type.value
        case .unknown(let type):
            return type.value
        }
    }

    ///Human readable description of status code value
    public var description: String {
        switch self {
        case .info(let type):
            return type.description
        case .success(let type):
            return type.description
        case .redirection(let type):
            return type.description
        case .clientError(let type):
            return type.description
        case .serverError(let type):
            return type.description
        case .unknown(let type):
            return type.description
        }
    }
    
    /**
     Creates suitable status code based on given HTTP status code value.

     - Parameter value: HTTP status code value.
     */
    init(_ value: Int) {
        if let code = InfoStatusCodeType(value) {
            self = .info(code)
        } else if let code = SuccessStatusCodeType(value) {
            self = .success(code)
        } else if let code = RedirectionStatusCodeType(value) {
            self = .redirection(code)
        } else if let code = ClientErrorStatusCodeType(value) {
            self = .clientError(code)
        } else if let code = ServerErrorStatusCodeType(value) {
            self = .serverError(code)
        } else {
            self = .unknown(UnknownStatusCodeType(value))
        }
    }
}

extension StatusCode {

    private static let internalErrorCode = 999999

    ///Returns StatusCode for library internal error.
    static var internalError: StatusCode {
        return .unknown(UnknownStatusCodeType(internalErrorCode))
    }

    ///Allows to check if StatusCode is status of library internal error.
    public var isInternalError: Bool {
        switch self {
        case .unknown(let code) where code.value == type(of: self).internalErrorCode:
            return true
        default:
            return false
        }
    }

    ///Allows to check if StatusCode is status of informational response.
    public var isInfo: Bool {
        switch self {
        case .info(_):
            return true
        default:
            return false
        }
    }

    ///Allows to check if StatusCode is status of success response.
    public var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        default:
            return false
        }
    }

    ///Allows to check if StatusCode is status of redirection response.
    public var isRedirection: Bool {
        switch self {
        case .redirection(_):
            return true
        default:
            return false
        }
    }

    ///Allows to check if StatusCode is status of error response.
    public var isError: Bool {
        switch self {
        case .clientError(_), .serverError(_), .unknown(_):
            return true
        default:
            return false
        }
    }
}

extension StatusCode: Equatable {

    public static func ==(lhs: StatusCode, rhs: StatusCode) -> Bool {
        switch (lhs, rhs) {
        case (.info(let code1), .info(let code2)) where code1 == code2:
            return true
        case (.success(let code1), .success(let code2)) where code1 == code2:
            return true
        case (.redirection(let code1), .redirection(let code2)) where code1 == code2:
            return true
        case (.clientError(let code1), .clientError(let code2)) where code1 == code2:
            return true
        case (.serverError(let code1), .serverError(let code2)) where code1 == code2:
            return true
        case (.unknown(let code1), .unknown(let code2)) where code1 == code2:
            return true
        default:
            return false
        }
    }

    /**
     Returns a Boolean value indicating whether given StatusCodes belongs to the same familly.

     - Parameter code: StatusCode to compare with.
     */
    public func isEqualByType(with code: StatusCode) -> Bool {
        switch (self, code) {
        case (.info(_), .info(_)):
            return true
        case (.success(_), .success(_)):
            return true
        case (.redirection(_), .redirection(_)):
            return true
        case (.clientError(_), .clientError(_)):
            return true
        case (.serverError(_), .serverError(_)):
            return true
        case (.unknown(_), .unknown(_)):
            return true
        default:
            return false
        }
    }
}
