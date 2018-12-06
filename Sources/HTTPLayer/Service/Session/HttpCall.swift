//
//  HttpCall.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 08.03.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import Foundation

typealias SessionServiceProgressHandler = (_ totalBytesProcessed: Int64, _ totalBytesExpectedToProcess: Int64) -> ()
typealias SessionServiceSuccessHandler = (_ response: HttpResponse) -> ()
typealias SessionServiceFailureHandler = (_ error: Error) -> ()

final class HttpCall {
    
    private let progressBlock: SessionServiceProgressHandler
    private let successBlock: SessionServiceSuccessHandler
    private let failureBlock: SessionServiceFailureHandler
    private(set) var response: HttpResponse?

    private var unknownError: Error {
        return NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
    }

    init(progressBlock: @escaping SessionServiceProgressHandler, successBlock: @escaping SessionServiceSuccessHandler, failureBlock: @escaping SessionServiceFailureHandler) {
        self.progressBlock = progressBlock
        self.successBlock = successBlock
        self.failureBlock = failureBlock
    }

    func update(with urlResponse: URLResponse) {
        if response == nil {
            response = HttpResponse(urlResponse: urlResponse)
        } else {
            response?.update(with: urlResponse)
        }
    }

    func update(with data: Data) {
        if response == nil {
            response = HttpResponse(body: data)
        } else {
            response?.appendBody(data)
        }
    }

    func update(with resourceUrl: URL) {
        if response == nil {
            response = HttpResponse(resourceUrl: resourceUrl)
        } else {
            response?.update(with: resourceUrl)
        }
    }

    func performProgress(totalBytesProcessed: Int64, totalBytesExpectedToProcess: Int64) {
        progressBlock(totalBytesProcessed, totalBytesExpectedToProcess)
    }

    func performFailure(with error: Error?) {
        //Action should run on other thread to not block delegate.
        DispatchQueue.global().async {
            self.failureBlock(error ?? self.unknownError)
        }
    }

    func performSuccess(with response: HttpResponse) {
        //Action should run on other thread to not block delegate.
        DispatchQueue.global().async {
            self.successBlock(response)
        }
    }
}
