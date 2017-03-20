//
//  ApiRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct ApiRequest {

    ///Http request to manage.
    private let request: HttpRequest

    ///RequestService allowing to manage request.
    private let requestService: RequestService

    ///Creates request based on HttpRequest and RequestService.
    init(httpRequest: HttpRequest, httpRequestService: RequestService) {
        self.request = httpRequest
        self.requestService = httpRequestService
    }

    ///Unique id of request.
    public var uuid: UUID {
        return request.uuid
    }

    ///Progress object which allows to follow request progress.
    public var progress: Progress? {
        return request.progress
    }

    ///Temporarily suspends request.
    public func suspend() {
        requestService.suspend(request)
    }

    ///Resumes request, if it is suspended.
    @available(iOS 9.0, OSX 10.11, *)
    public func resume() {
        requestService.resume(request)
    }

    ///Cancels request.
    public func cancel() {
        requestService.cancel(request)
    }
}
