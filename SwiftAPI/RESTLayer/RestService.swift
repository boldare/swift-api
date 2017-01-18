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

    ///Uploads file with given parameters
    fileprivate func uploadFile(at localFileUrl:URL, to destinationUrl:URL, inBackground: Bool, method: HttpMethod, useProgress: Bool, completionHandler: ResponseCompletionHandler?) -> RestRequest  {
        let action = completionActions(for: completionHandler)
        let uploadRequest = HttpUploadRequest(url: destinationUrl, method: method, resourceUrl: localFileUrl, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(uploadRequest, in: (inBackground ? .background : .foreground))

        return RestRequest(httpRequest: uploadRequest, httpRequestService: requestService)
    }

    ///Downloads file with given parameters
    fileprivate func downloadFile(from remoteFileUrl:URL, to localUrl:URL, inBackground: Bool, useProgress: Bool, completionHandler: ResponseCompletionHandler?) -> RestRequest  {
        let action = completionActions(for: completionHandler)
        let downloadRequest = HttpDownloadRequest(url: remoteFileUrl, destinationUrl: localUrl, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(downloadRequest, in: (inBackground ? .background : .foreground))

        return RestRequest(httpRequest: downloadRequest, httpRequestService: requestService)
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
    func post(data: Data, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
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
    func put(data: Data, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
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
    func patch(data: Data, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
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
    func delete(data: Data? = nil, at url: URL, useProgress: Bool = false, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
        return sendRequest(url: url, method: .delete, body: data, useProgress: useProgress, completionHandler: completionHandler)
    }
}

extension RestService {

    /**
     Uploads file using HTTP POST request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - destinationUrl: URL of the receiver.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func postFile(from localFileUrl:URL, to destinationUrl:URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .post, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Uploads file using HTTP PUT request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - destinationUrl: URL of the receiver.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func putFile(from localFileUrl:URL, to destinationUrl:URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .put, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Uploads file using HTTP PATCH request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - destinationUrl: URL of the receiver.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     */
    func patchFile(from localFileUrl:URL, to destinationUrl:URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .patch, useProgress: useProgress, completionHandler: completionHandler)
    }
}

extension RestService {

    /**
     Downloads file using HTTP GET request.

     - Parameters:
       - remoteFileUrl: URL of remote file to download.
       - localUrl: URL on disc indicates where file should be saved. 
       - inBackground: Flag indicates if downloading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: RestRequest object which allows to follow progress and manage request.
     
     - Important: If any file exists at *localUrl* it will be overridden by downloaded file.
     */
    func download(from remoteFileUrl:URL, to localUrl:URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: ResponseCompletionHandler? = nil) -> RestRequest {
        return downloadFile(from: remoteFileUrl, to: localUrl, inBackground: inBackground, useProgress: useProgress, completionHandler: completionHandler)
    }
}
