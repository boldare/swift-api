//
//  RestService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

typealias ResponseCompletionHandler = (RestResponse?, Error?) -> ()

final class RestService {

    private let requestService: RequestService

    ///Creates success and failure action for single completion handler
    private func completionActions(for completion: ResponseCompletionHandler?) -> (success: ResponseAction, failure: ResponseAction) {
        let success = ResponseAction.success { (response) in
            if let response = RestResponse(response) {
                completion?(response, nil)
            } else {
                completion?(nil, RestError.noResponse)
            }
        }
        let failure = ResponseAction.failure { (error) in
            completion?(nil, error)
        }
        return (success, failure)
    }

    ///Sends data request with given parameters
    fileprivate func sendRequest(url: URL, method: HttpMethod, body: Data?, useProgress: Bool, completionHandler: ResponseCompletionHandler?) -> RestRequest {
        let action = completionActions(for: completionHandler)
        let httpRequest = HttpDataRequest(url: url, method: method, body: body, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(httpRequest)

        return RestRequest(httpRequest: httpRequest, httpRequestService: requestService)
    }

    ///Initializes service with given file manager.
    init(fileManager: FileManagerProtocol) {
        self.requestService = RequestService(fileManager: fileManager)
    }
}

extension RestService {

    /**
     Sends HTTP GET request with given parameters.

     - Parameters:
       - url: URL of the receiver.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func get(from url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
        return sendRequest(url: url, method: .get, body: nil, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP POST request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func post(data: Data, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler?) -> RestRequest {
        return sendRequest(url: url, method: .post, body: data, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP PUT request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func put(data: Data, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler?) -> RestRequest {
        return sendRequest(url: url, method: .put, body: data, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP PATCH request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func patch(data: Data, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler?) -> RestRequest {
        return sendRequest(url: url, method: .patch, body: data, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP DELETE request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func delete(data: Data? = nil, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler?) -> RestRequest {
        return sendRequest(url: url, method: .delete, body: data, useProgress: useProgress, completionHandler: completionHandler)
    }
}
