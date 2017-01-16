//
//  StatusCode.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

enum StatusCode {
    case info(InfoStatusCodeType)
    case success(SuccessStatusCodeType)
    case redirection(RedirectionStatusCodeType)
    case clientError(ClientErrorStatusCodeType)
    case serverError(ServerErrorStatusCodeType)
    case unknown(UnknownStatusCodeType)
}

extension StatusCode {
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
