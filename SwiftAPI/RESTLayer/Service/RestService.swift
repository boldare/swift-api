//
//  RestService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 03.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public class RestService {

    ///Base URL of API server. Remember not to finish it with */* sign.
    public let baseUrl: URL

    ///Path string of API on server. May be used for versioning. Remember to star it with */* sign.
    public let apiPath: String

    ///Array of aditional HTTP header fields.
    private let headerFields: [ApiHeader]?

    ///File manager.
    private let fileManager: FileManagerProtocol

    ///Service for managing request with REST server.
    fileprivate lazy var apiService: ApiService = { [unowned self] in
        return ApiService(fileManager: self.fileManager)
    }()

    ///Creates full url by joining *baseUrl* and *apiPath*.
    fileprivate func requestUrl(for resourceName: String) -> URL {
        return baseUrl.appendingPathComponent(apiPath).appendingPathComponent(resourceName)
    }

    ///Merges *headerFields* with aditional headers.
    fileprivate func apiHeaders(adding headers: [ApiHeader]?) -> [ApiHeader]? {
        guard let headers = headers else {
            return headerFields
        }
        var mergedHeders = headerFields
        mergedHeders?.append(contentsOf: headers)
        return mergedHeders
    }

    ///Converts RestResponseCimpletionHandler into ApiResponseCompletionHandler
    fileprivate func completionHandler(for resource: RestResource, with restHandler: RestResponseCompletionHandler?) -> ApiResponseCompletionHandler? {
        guard let restHandler = restHandler else {
            return nil
        }
        return { (response: ApiResponse?, error: Error?) in
            var resource = resource
            var errorResponse: RestErrorResponse?
            if let internalError = error {
                errorResponse = RestErrorResponse(error: internalError)
            } else if let r = response, let apiError = ApiError.error(for: r.statusCode) {
                errorResponse = RestErrorResponse(error: apiError)
            } else if let r = response, let parsingError = resource.updateWith(responseData: r.body, aditionalInfo: RestResponseHeader.responseHeaders(with: r.allHeaderFields)) {
                errorResponse = RestErrorResponse(error: parsingError)
            }
            restHandler(resource, errorResponse)
        }
    }

    ///Converts RestFileResponseCompletionHandler into ApiResponseCompletionHandler
    fileprivate func completionHandler(for resource: RestFileResource, with restHandler: RestFileResponseCompletionHandler?) -> ApiResponseCompletionHandler? {
        guard let restHandler = restHandler else {
            return nil
        }
        return { (response: ApiResponse?, error: Error?) in
            var errorResponse: RestErrorResponse?
            if let internalError = error {
                errorResponse = RestErrorResponse(error: internalError)
            } else if let r = response, let apiError = ApiError.error(for: r.statusCode) {
                errorResponse = RestErrorResponse(error: apiError)
            }
            restHandler(resource, errorResponse)
        }
    }

    public init(baseUrl: URL, apiPath: String, headerFields: [ApiHeader]?, fileManager: FileManagerProtocol) {
        self.baseUrl = baseUrl
        self.apiPath = apiPath
        self.fileManager = fileManager
        self.headerFields = headerFields
    }
}

//MARK: Simple requests
public extension RestService {

    /**
     Sends HTTP GET request for given resource.

     - Parameters:
       - resource: RestResource object which should be filled up with response data.
       - aditionalHeaders: Additional header fields which should be sent with request.
       - useProgress: Flag indicates if Progress object should be created.
       - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func get(resource: RestResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.get(from: url, with: headers, useProgress: useProgress, completionHandler: handler)
    }

    /**
     Sends HTTP POST request with given resource.

     - Parameters:
       - resource: RestResource object which should be send and filled up with response data.
       - aditionalHeaders: Additional header fields which should be sent with request.
       - useProgress: Flag indicates if Progress object should be created.
       - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func post(resource: RestResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.post(data: resource.dataRepresentation, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
    }

    /**
     Sends HTTP PUT request with given resource.

     - Parameters:
       - resource: RestResource object which should be send and filled up with response data.
       - aditionalHeaders: Additional header fields which should be sent with request.       
       - useProgress: Flag indicates if Progress object should be created.
       - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func put(resource: RestResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.put(data: resource.dataRepresentation, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
    }

    /**
     Sends HTTP PATCH request with given resource.

     - Parameters:
       - resource: RestResource object which should be send and filled up with response data.
       - aditionalHeaders: Additional header fields which should be sent with request.
       - useProgress: Flag indicates if Progress object should be created.
       - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func patch(resource: RestResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.patch(data: resource.dataRepresentation, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
    }

    /**
     Sends HTTP DELETE request for given resource.

     - Parameters:
       - resource: RestResource object which should be filled up with response data.
       - aditionalHeaders: Additional header fields which should be sent with request.
       - useProgress: Flag indicates if Progress object should be created.
       - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func delete(resource: RestResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.delete(data: resource.dataRepresentation, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
    }
}

//MARK: File managing
public extension RestService {

    /**
     Sends HTTP GET request for given resource.

     - Parameters:
     - resource: RestResource object which should be filled up with response data.
     - aditionalHeaders: Additional header fields which should be sent with request.
     - useProgress: Flag indicates if Progress object should be created.
     - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func getFile(resource: RestFileResource, inBackground: Bool = true, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = true, completion: RestFileResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.download(from: url, to: resource.location, with: headers, inBackground: inBackground, useProgress: useProgress, completionHandler: handler)
    }

    /**
     Sends HTTP POST request with given resource.

     - Parameters:
     - resource: RestResource object which should be send and filled up with response data.
     - aditionalHeaders: Additional header fields which should be sent with request.
     - useProgress: Flag indicates if Progress object should be created.
     - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func postFile(resource: RestFileResource, inBackground: Bool = true, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = true, completion: RestFileResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.postFile(from: resource.location, to: url, with: headers, inBackground: inBackground, useProgress: useProgress, completionHandler: handler)
    }

    /**
     Sends HTTP PUT request with given resource.

     - Parameters:
     - resource: RestResource object which should be send and filled up with response data.
     - aditionalHeaders: Additional header fields which should be sent with request.
     - useProgress: Flag indicates if Progress object should be created.
     - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func putFile(resource: RestFileResource, inBackground: Bool = true, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = true, completion: RestFileResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.putFile(from: resource.location, to: url, with: headers, inBackground: inBackground, useProgress: useProgress, completionHandler: handler)
    }

    /**
     Sends HTTP PATCH request with given resource.

     - Parameters:
     - resource: RestResource object which should be send and filled up with response data.
     - aditionalHeaders: Additional header fields which should be sent with request.
     - useProgress: Flag indicates if Progress object should be created.
     - completion: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func patchFile(resource: RestFileResource, inBackground: Bool = true, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = true, completion: RestFileResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.patchFile(from: resource.location, to: url, with: headers, inBackground: inBackground, useProgress: useProgress, completionHandler: handler)
    }
}
