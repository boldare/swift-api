//
//  RestRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

struct RestRequest {

    private let request: HttpRequest
    private let requestService: RequestService

    ///Progress object which allows to follow request progress.
    var progress: Progress? {
        return request.progress
    }

    ///Creates request based on HttpRequest and RequestService.
    init(httpRequest: HttpRequest, httpRequestService: RequestService) {
        self.request = httpRequest
        self.requestService = httpRequestService
    }

    ///Temporarily suspends request.
    func suspend() {
        requestService.suspend(request)
    }

    ///Resumes request, if it is suspended.
    func resume() {
        requestService.resume(request)
    }

    ///Cancels request.
    func cancel() {
        requestService.cancel(request)
    }
}
