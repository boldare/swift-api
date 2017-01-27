//
//  RestService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

final class RestService {

    ///Base URL of API server. Remember not to finish it with */* sign.
    let baseUrl: URL

    ///Path string of API on server. May be used for versioning. Remember to star it with */* sign.
    let apiPath: String

    private let requestService: RequestService

    /**
     - Parameters:
       - baseUrl: URL object containing base URL of API server.
       - apiPath: String containing path of API on server.
       - fileManager: Object of class implementing *FileManagerProtocol*.
     
     - Important: Remember that *baseUrl* should not end with / sign, and *apiPath* should start with / sign.
     */
    init(baseUrl: URL, apiPath: String, fileManager: FileManagerProtocol) {
        self.baseUrl = baseUrl
        self.apiPath = apiPath
        self.requestService = RequestService(fileManager: fileManager)
    }

    //MARK: - Convenient methods
    ///Creates full url by joining *baseUrl* and *apiPath*.
    fileprivate func requestUrl(for resourceName: String) -> URL {
        return baseUrl.appendingPathComponent(apiPath).appendingPathComponent(resourceName)
    }

    ///Sends data request with given parameters
    fileprivate func sendRequestForResource(named: String, method: HttpMethod, body: Data?, headers: [HttpHeader]?, useProgress: Bool, completionHandler: WebResponseCompletionHandler?) -> WebRequest {
        let url = requestUrl(for: named)
        let action = ResponseAction.completionActions(for: completionHandler)
        let httpRequest = HttpDataRequest(url: url, method: method, body: body, headers: headers, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(httpRequest)

        return WebRequest(httpRequest: httpRequest, httpRequestService: requestService)
    }

    ///Uploads file with given parameters
    fileprivate func uploadFile(at localFileUrl: URL, forResource resourceName: String, inBackground: Bool, method: HttpMethod, headers: [HttpHeader]?, useProgress: Bool, completionHandler: WebResponseCompletionHandler?) -> WebRequest  {
        let destinationUrl = requestUrl(for: resourceName)
        let action = ResponseAction.completionActions(for: completionHandler)
        let uploadRequest = HttpUploadRequest(url: destinationUrl, method: method, resourceUrl: localFileUrl, headers: headers, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(uploadRequest, in: (inBackground ? .background : .foreground))

        return WebRequest(httpRequest: uploadRequest, httpRequestService: requestService)
    }

    ///Downloads file with given parameters
    fileprivate func downloadFileResource(named: String, to localUrl: URL, inBackground: Bool, headers: [HttpHeader]?, useProgress: Bool, completionHandler: WebResponseCompletionHandler?) -> WebRequest  {
        let remoteFileUrl = requestUrl(for: named)
        let action = ResponseAction.completionActions(for: completionHandler)
        let downloadRequest = HttpDownloadRequest(url: remoteFileUrl, destinationUrl: localUrl, headers: headers, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(downloadRequest, in: (inBackground ? .background : .foreground))

        return WebRequest(httpRequest: downloadRequest, httpRequestService: requestService)
    }
}

extension RestService {

    /**
     Sends HTTP GET request with given parameters.

     - Parameters:
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func get(resource resourceName: String, with aditionalHeaders: [HttpHeader]? = nil,  useProgress: Bool = false, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return sendRequestForResource(named: resourceName, method: .get, body: nil, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP POST request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func post(data: Data, forResource resourceName: String, with aditionalHeaders: [HttpHeader]? = nil, useProgress: Bool = false, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return sendRequestForResource(named: resourceName, method: .post, body: data, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP PUT request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func put(data: Data, forResource resourceName: String, with aditionalHeaders: [HttpHeader]? = nil, useProgress: Bool = false, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return sendRequestForResource(named: resourceName, method: .put, body: data, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP PATCH request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func patch(data: Data, forResource resourceName: String, with aditionalHeaders: [HttpHeader]? = nil, useProgress: Bool = false, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return sendRequestForResource(named: resourceName, method: .patch, body: data, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP DELETE request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func delete(resource resourceName: String, data: Data? = nil, with aditionalHeaders: [HttpHeader]? = nil, useProgress: Bool = false, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return sendRequestForResource(named: resourceName, method: .delete, body: data, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }
}

extension RestService {

    /**
     Uploads file using HTTP POST request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func postFile(from localFileUrl: URL, forResource resourceName: String, with aditionalHeaders: [HttpHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return uploadFile(at: localFileUrl, forResource: resourceName, inBackground: inBackground, method: .post, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Uploads file using HTTP PUT request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func putFile(from localFileUrl: URL, forResource resourceName: String, with aditionalHeaders: [HttpHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return uploadFile(at: localFileUrl, forResource: resourceName, inBackground: inBackground, method: .put, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Uploads file using HTTP PATCH request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - resourceName: String containing REST resource name.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func patchFile(from localFileUrl: URL, forResource resourceName: String, with aditionalHeaders: [HttpHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return uploadFile(at: localFileUrl, forResource: resourceName, inBackground: inBackground, method: .patch, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }
}

extension RestService {

    /**
     Downloads file using HTTP GET request.

     - Parameters:
       - resourceName: String containing REST resource name.
       - localUrl: URL on disc indicates where file should be saved.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if downloading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     
     - Important: If any file exists at *localUrl* it will be overridden by downloaded file.
     */
    func download(resource resourceName: String, to localUrl: URL, with aditionalHeaders: [HttpHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return downloadFileResource(named: resourceName, to: localUrl, inBackground: inBackground, headers: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }
}
