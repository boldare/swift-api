//
//  RemoteFileService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 23.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

class RemoteFileService: NSObject {

    ///Array of HTTP header fields.
    let headerFields: [HttpHeader]?

    private let requestService: RequestService

    /**
     - Parameters:
       - headers: Array of all aditional HTTP header fields.
       - fileManager: Object of class implementing *FileManagerProtocol*.
     */
    init(headers: [HttpHeader]?, fileManager: FileManagerProtocol) {
        self.requestService = RequestService(fileManager: fileManager)
        self.headerFields = headers
    }

    ///Uploads file with given parameters
    fileprivate func uploadFile(at localFileUrl: URL, to destinationUrl: URL, inBackground: Bool, method: HttpMethod, useProgress: Bool, completionHandler: WebResponseCompletionHandler?) -> WebRequest  {
        let action = ResponseAction.completionActions(for: completionHandler)
        let uploadRequest = HttpUploadRequest(url: destinationUrl, method: method, resourceUrl: localFileUrl, headers: headerFields, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(uploadRequest, in: (inBackground ? .background : .foreground))

        return WebRequest(httpRequest: uploadRequest, httpRequestService: requestService)
    }

    ///Downloads file with given parameters
    fileprivate func downloadFile(from remoteFileUrl: URL, to localUrl: URL, inBackground: Bool, useProgress: Bool, completionHandler: WebResponseCompletionHandler?) -> WebRequest  {
        let action = ResponseAction.completionActions(for: completionHandler)
        let downloadRequest = HttpDownloadRequest(url: remoteFileUrl, destinationUrl: localUrl, headers: headerFields, onSuccess: action.success, onFailure: action.failure, useProgress: useProgress)

        requestService.sendHTTPRequest(downloadRequest, in: (inBackground ? .background : .foreground))

        return WebRequest(httpRequest: downloadRequest, httpRequestService: requestService)
    }
}

extension RemoteFileService {

    /**
     Uploads file using HTTP POST request.

     - Parameters:
       - localFileUrl: URL on disc of the resource to upload.
       - destinationUrl: URL of the receiver.
       - inBackground: Flag indicates if uploading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func postFile(from localFileUrl: URL, to destinationUrl: URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .post, useProgress: useProgress, completionHandler: completionHandler)
    }

    /**
     Uploads file using HTTP PUT request.

     - Parameters:
     - localFileUrl: URL on disc of the resource to upload.
     - resourceName: String containing REST resource name.
     - inBackground: Flag indicates if uploading should be performed in background or foreground.
     - useProgress: Flag indicates if Progress object should be created.
     - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func putFile(from localFileUrl: URL, to destinationUrl: URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
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

     - Returns: WebRequest object which allows to follow progress and manage request.
     */
    func patchFile(from localFileUrl: URL, to destinationUrl: URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return uploadFile(at: localFileUrl, to: destinationUrl, inBackground: inBackground, method: .patch, useProgress: useProgress, completionHandler: completionHandler)
    }
}

extension RemoteFileService {

    /**
     Downloads file using HTTP GET request.

     - Parameters:
       - resourceUrl: URL of resource to download.
       - localUrl: URL on disc indicates where file should be saved.
       - inBackground: Flag indicates if downloading should be performed in background or foreground.
       - useProgress: Flag indicates if Progress object should be created.
       - completionHandler: Closure called when request is finished.

     - Returns: WebRequest object which allows to follow progress and manage request.

     - Important: If any file exists at *localUrl* it will be overridden by downloaded file.
     */
    func download(from resourceUrl: URL, to localUrl: URL, inBackground: Bool = true, useProgress: Bool = true, completionHandler: WebResponseCompletionHandler? = nil) -> WebRequest {
        return downloadFile(from: resourceUrl, to: localUrl, inBackground: inBackground, useProgress: useProgress, completionHandler: completionHandler)
    }
}
