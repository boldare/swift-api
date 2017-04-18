//
//  ApiService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 13.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

final public class ApiService {

    ///Service managing requests
    internal let requestService: RequestService

    ///Converts array of *ApiHeader* to array of *HttpHeader*
    private func httpHeaders(for apiHeaders:[ApiHeader]?) -> [HttpHeader]? {
        guard let apiHeaders = apiHeaders else {
            return nil
        }
        var headers = [HttpHeader]()
        for header in apiHeaders {
            headers.append(header.httpHeader)
        }
        return headers
    }

    ///Sends data request with given parameters
    fileprivate func sendRequest(url: URL, method: HttpMethod, body: Data?, apiHeaders: [ApiHeader]?, useProgress: Bool, completionHandler: ApiResponseCompletionHandler?) -> ApiRequest {
        let headers = httpHeaders(for: apiHeaders)
        let action = ResponseAction.completionActions(for: completionHandler)
        let httpRequest = HttpDataRequest(url: url, method: method, body: body, headers: headers, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(httpRequest)

        return ApiRequest(httpRequest: httpRequest, httpRequestService: requestService)
    }

    ///Uploads file with given parameters
    fileprivate func uploadFile(at localFileUrl: URL, to destinationUrl: URL, inBackground: Bool, method: HttpMethod, apiHeaders: [ApiHeader]?, useProgress: Bool, completionHandler: ApiResponseCompletionHandler?) -> ApiRequest  {
        let headers = httpHeaders(for: apiHeaders)
        let action = ResponseAction.completionActions(for: completionHandler)
        let uploadRequest = HttpUploadRequest(url: destinationUrl, method: method, resourceUrl: localFileUrl, headers: headers, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(uploadRequest, in: (inBackground ? .background : .foreground))

        return ApiRequest(httpRequest: uploadRequest, httpRequestService: requestService)
    }

    ///Downloads file with given parameters
    fileprivate func downloadFile(from remoteFileUrl: URL, to localUrl: URL, inBackground: Bool, apiHeaders: [ApiHeader]?, useProgress: Bool, completionHandler: ApiResponseCompletionHandler?) -> ApiRequest  {
        let headers = httpHeaders(for: apiHeaders)
        let action = ResponseAction.completionActions(for: completionHandler)
        let downloadRequest = HttpDownloadRequest(url: remoteFileUrl, destinationUrl: localUrl, headers: headers, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(downloadRequest, in: (inBackground ? .background : .foreground))

        return ApiRequest(httpRequest: downloadRequest, httpRequestService: requestService)
    }

    /**
     - Parameter fileManager: Object of class implementing *FileManagerProtocol*.
     */
    public init(fileManager: FileManagerProtocol = FileCommander()) {
        self.requestService = RequestService(fileManager: fileManager)
    }

    ///Cancels all currently running requests.
    public func cancelAllRequests() {
        requestService.cancelAllRequests()
    }
}

///Manage simple HTTP requests
public extension ApiService {

    /**
     Sends HTTP GET request with given parameters.

     - Parameters:
       - url: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func getData(from url: URL, with aditionalHeaders: [ApiHeader]? = nil,  useProgress: Bool = false, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return sendRequest(url: url, method: .get, body: nil, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP POST request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func post(data: Data?, at url: URL, with aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return sendRequest(url: url, method: .post, body: data, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP PUT request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func put(data: Data?, at url: URL, with aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return sendRequest(url: url, method: .put, body: data, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP PATCH request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func patch(data: Data?, at url: URL, with aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return sendRequest(url: url, method: .patch, body: data, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Sends HTTP DELETE request with given parameters.

     - Parameters:
       - data: Data object which supposed to be send.
       - url: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func delete(data: Data? = nil, at url: URL, with aditionalHeaders: [ApiHeader]? = nil, useProgress: Bool = false, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return sendRequest(url: url, method: .delete, body: data, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }
}

///Manage uploading files
public extension ApiService {

    /**
     Uploads file using HTTP POST request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - destinationUrl: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func postFile(from localFileUrl: URL, to destinationUrl: URL, with aditionalHeaders: [ApiHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .post, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Uploads file using HTTP PUT request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - destinationUrl: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func putFile(from localFileUrl: URL, to destinationUrl: URL, with aditionalHeaders: [ApiHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .put, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Uploads file using HTTP PATCH request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - destinationUrl: URL of the receiver.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     */
    func patchFile(from localFileUrl: URL, to destinationUrl: URL, with aditionalHeaders: [ApiHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .patch, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }
}

///Manage downloading files
public extension ApiService {

    /**
     Downloads file using HTTP GET request.

     - Parameters:
       - remoteFileUrl: URL of remote file to download.
       - localUrl: URL on disc indicates where file should be saved.
       - aditionalHeaders: Array of all aditional HTTP header fields.
       - inBackground: Flag indicates if downloading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: ApiRequest object which allows to follow progress and manage request.
     
     - Important: If any file exists at *localUrl* it will be overridden by downloaded file.
     */
    func downloadFile(from remoteFileUrl: URL, to localUrl: URL, with aditionalHeaders: [ApiHeader]? = nil, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ApiResponseCompletionHandler? = nil) -> ApiRequest {
        return downloadFile(from: remoteFileUrl, to: localUrl, inBackground: inBackground, apiHeaders: aditionalHeaders, useProgress: useProgress, completionHandler: completionHandler)
    }
}
