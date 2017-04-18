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

    ///Path of API on server. May be used for versioning. Remember to star it with */* sign.
    public let apiPath: String

    ///Array of aditional HTTP header fields.
    private let headerFields: [ApiHeader]?

    ///Service for managing request with REST server.
    internal let apiService: ApiService

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

    ///Converts RestDataResponseCimpletionHandler into ApiResponseCompletionHandler
    fileprivate func completionHandler(for resource: RestDataResource, with restHandler: RestDataResponseCompletionHandler?) -> ApiResponseCompletionHandler? {
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
            } else if let r = response, let parsingError = resource.update(with: r.body, aditionalInfo: RestResponseHeader.list(with: r.allHeaderFields)) {
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
            var resource = resource
            var errorResponse: RestErrorResponse?
            if let internalError = error {
                errorResponse = RestErrorResponse(error: internalError)
            } else if let r = response, let apiError = ApiError.error(for: r.statusCode) {
                errorResponse = RestErrorResponse(error: apiError)
            } else if let r = response, let updatingError = resource.update(with: RestResponseHeader.list(with: r.allHeaderFields)) {
                errorResponse = RestErrorResponse(error: updatingError)
            }
            restHandler(resource, errorResponse)
        }
    }

    /**
     - Parameters:
       - baseUrl: Base URL of API server.
       - apiPath: Path of API on server.
       - headerFields: Array of HTTP header fields which will be added to all requests.
       - fileManager: Object of class implementing *FileManagerProtocol*.
     */
    public init(baseUrl: URL, apiPath: String, headerFields: [ApiHeader]?, fileManager: FileManagerProtocol = FileCommander()) {
        self.baseUrl = baseUrl
        self.apiPath = apiPath
        self.headerFields = headerFields
        self.apiService = ApiService(fileManager: fileManager)
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
    func get(resource: RestDataResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestDataResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.getData(from: url, with: headers, useProgress: useProgress, completionHandler: handler)
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
    func post(resource: RestDataResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestDataResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.post(data: resource.data, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
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
    func put(resource: RestDataResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestDataResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.put(data: resource.data, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
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
    func patch(resource: RestDataResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestDataResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.patch(data: resource.data, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
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
    func delete(resource: RestDataResource, aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completion: RestDataResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let headers = apiHeaders(adding: aditionalHeaders)
        let handler = completionHandler(for: resource, with: completion)
        return apiService.delete(data: resource.data, at: url, with: headers, useProgress: useProgress, completionHandler: handler)
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
        return apiService.downloadFile(from: url, to: resource.location, with: headers, inBackground: inBackground, useProgress: useProgress, completionHandler: handler)
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

//MARK: Requests managing
public extension RestService {

    ///Cancels all currently running requests.
    func cancelAllRequests() {
        apiService.cancelAllRequests()
    }
}
