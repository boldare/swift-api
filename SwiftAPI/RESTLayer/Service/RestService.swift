//
//  RestService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 03.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

/**
 Closure called when api request is finished.
 - Parameters:
   - resource: Resource returned from server if there is any.
   - error: Error which occurred while processing request.
 */
public typealias RestResponseCompletionHandler = (_ resource: RestResource?, _ error: Error?) -> ()


public class RestService {

    ///Base URL of API server. Remember not to finish it with */* sign.
    public let baseUrl: URL

    ///Path string of API on server. May be used for versioning. Remember to star it with */* sign.
    public let apiPath: String

    ///Array of aditional HTTP header fields.
    public private(set) var isAuthorized: Bool

    ///Array of aditional HTTP header fields.
    fileprivate var headerFields: [ApiHeader]?

    ///File manager.
    fileprivate let fileManager: FileManagerProtocol

    ///Service for managing request with REST server.
    fileprivate lazy var apiService: ApiService = { [unowned self] in
        return ApiService(fileManager: self.fileManager)
    }()

    public init(baseUrl: URL, apiPath: String, aditionalHeaders: [ApiHeader]?, fileManager: FileManagerProtocol) {
        self.baseUrl = baseUrl
        self.apiPath = apiPath
        self.isAuthorized = false
        self.fileManager = fileManager
        self.headerFields = aditionalHeaders
    }
}

fileprivate extension RestService {

    ///Creates full url by joining *baseUrl* and *apiPath*.
    func requestUrl(for resourceName: String) -> URL {
        return baseUrl.appendingPathComponent(apiPath).appendingPathComponent(resourceName)
    }

    func completionHandler(for restHandler: RestResponseCompletionHandler?) -> ApiResponseCompletionHandler? {
        guard let restHandler = restHandler else {
            return nil
        }
        return { (response: ApiResponse?, error: Error?) in

        }
    }
}

public extension RestService {

    func get(resource: RestResource, useProgress: Bool = false, completion: RestResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let handler = completionHandler(for: completion)
        return apiService.get(from: url, with: headerFields, useProgress: useProgress, completionHandler: handler)
    }

    func post(resource: RestResource, useProgress: Bool = false, completion: RestResponseCompletionHandler? = nil) -> ApiRequest {
        let url = requestUrl(for: resource.name)
        let handler = completionHandler(for: completion)
        return apiService.post(data: <#T##Data#>, at: url, with: headerFields, useProgress: useProgress, completionHandler: handler)
    }

    func put(resource: RestResource) -> ApiRequest? {

        return nil
    }

    func patch(resource: RestResource) -> ApiRequest? {
        
        return nil
    }
}
