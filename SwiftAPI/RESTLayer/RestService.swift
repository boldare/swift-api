//
//  RestService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

typealias RestSuccessResponse = (RestResponse?) -> ()
typealias RestErrorResponse = (Error) -> ()

class RestService {

    private let requestService: RequestService

    init(fileManager: FileManagerProtocol) {
        self.requestService = RequestService(fileManager: fileManager)
    }

    func get(from url: URL, success: RestSuccessResponse? = nil, failure: RestErrorResponse?) -> RestRequest {
        let successAction = ResponseAction.success { (response) in
            let statusCode: StatusCode
            if let code = response?.statusCode {
                statusCode = StatusCode(value: code)
            } else {
                statusCode = StatusCode.internalErrorStatusCode
            }

            if statusCode.isSuccessStatusCode {
                success?(RestResponse())
            }

        }
        let failureAction = ResponseAction.failure { (error) in
            failure?(error)
        }

        let httpRequest = HttpDataRequest(url: url, method: .get, onSuccess: successAction, onFailure: failureAction)
        let restRequest = RestRequest(httpRequest: httpRequest, httpRequestService: requestService)
        
        requestService.sendHTTPRequest(httpRequest)

        return restRequest
    }

   

}
