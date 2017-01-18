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
 - unknown: stores every  other status codes, it may be used for internal library errors.
 */
enum StatusCode {
    case info(InfoStatusCodeType)
    case success(SuccessStatusCodeType)
    case redirection(RedirectionStatusCodeType)
    case clientError(ClientErrorStatusCodeType)
    case serverError(ServerErrorStatusCodeType)
    case unknown(UnknownStatusCodeType)
}

extension StatusCode {

    /**
     Creates suitable status code based on given HTTP status code value.

     - Parameter value: HTTP status code value.
     */
    init(value: Int) {
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

    private static let internalErrorCode = 99999

    ///Returns StatusCode for library internal error.
    static var internalErrorStatusCode: StatusCode {
        return .unknown(UnknownStatusCodeType(internalErrorCode))
    }

    ///Allows to check if StatusCode is status of library internal error.
    var isInternalErrorStatusCode: Bool {
        switch self {
        case .unknown(let code) where code.value == type(of: self).internalErrorCode:
            return true
        default:
            return false
        }
    }

    ///Allows to check if StatusCode is status of success response.
    var isSuccessStatusCode: Bool {
        switch self {
        case .info(_), .success(_), .redirection(_):
            return true
        default:
            return false
        }
    }

    ///Allows to check if StatusCode is status of error response.
    var isErrorStatusCode: Bool {
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
    func isEqualByType(with code: StatusCode) -> Bool {
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
