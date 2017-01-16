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

    private let requestService = RequestService()

    func get(from url: URL, success: RestSuccessResponse? = nil, failure: RestErrorResponse?) -> RestRequest {
        let success = ResponseAction.success { (response) in

        }
        let failure = ResponseAction.failure { (error) in

        }
        let httpRequest = HttpDataRequest(url: url, method: .get, onSuccess: success, onFailure: failure)
        let restRequest = RestRequest(httpRequest: httpRequest, httpRequestService: requestService)
        
        requestService.sendHTTPRequest(httpRequest)

        return restRequest
    }

   

}
