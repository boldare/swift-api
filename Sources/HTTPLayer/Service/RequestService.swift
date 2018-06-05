//
//  APIRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

final class RequestService: NSObject {

    private let fileManager: FileManager

    //MARK: - Handling multiple sessions
    private var activeSessions = [Configuration: SessionService]()

    ///Returns URLSession for given configuration. If session does not exist, it creates one.
    private func activeSession(for configuration: Configuration) -> SessionService {
        if let session = activeSessions[configuration], session.isValid {
            return session
        }
        activeSessions.removeValue(forKey: configuration)
        let service = SessionService(configuration: configuration)
        activeSessions[configuration] = service
        return service
    }

    //MARK: - Handling background sessions
    ///Keeps completion handler for background sessions.
    lazy var backgroundSessionCompletionHandler = [String : () -> Void]()

    //MARK: Initialization
    ///Initializes service with given file manager.
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    deinit {
        activeSessions.forEach { $0.value.invalidateAndCancel() }
    }
}

//MARK: - Managing requests
extension RequestService {

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpDataRequest object provides request-specific information such as the URL, HTTP method or body data.
       - configuration: RequestService.Configuration indicates request configuration.

     HttpDataRequest may run only with foreground configuration.
     */
    func sendHTTPRequest(_ request: HttpDataRequest, with configuration: Configuration = .foreground) {
        let session = activeSession(for: configuration)
        session.data(request: request.urlRequest, progress: progress(for: request), success: success(for: request), failure: failure(for: request))
    }

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpUploadRequest object provides request-specific information such as the URL, HTTP method or URL of the file to upload.
       - configuration: RequestService.Configuration indicates upload request configuration.
     */
    func sendHTTPRequest(_ request: HttpUploadRequest, with configuration: Configuration = .background) {
        let session = activeSession(for: configuration)
        session.upload(request: request.urlRequest, file: request.resourceUrl, progress: progress(for: request), success: success(for: request), failure: failure(for: request))
    }

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpUploadRequest object provides request-specific information such as the URL, HTTP method or URL of the place on disc for downloading file.
       - configuration: RequestService.Configuration indicates download request configuration.
     */
    func sendHTTPRequest(_ request: HttpDownloadRequest, with configuration: Configuration = .background) {
        let session = activeSession(for: configuration)
        session.download(request: request.urlRequest, progress: progress(for: request), success: success(forDownload: request), failure: failure(for: request))
    }

    /**
     Temporarily suspends given HTTP request.

     - Parameter request: An HttpRequest to suspend.
     */
    func suspend(_ request: HttpRequest) {
        activeSessions.forEach{ $0.value.suspend(request.urlRequest) }
        request.progress?.pause()
    }

    /**
     Resumes given HTTP request, if it is suspended.

     - Parameter request: An HttpRequest to resume.
     */
    @available(iOS 9.0, OSX 10.11, *)
    func resume(_ request: HttpRequest) {
        activeSessions.forEach{ $0.value.resume(request.urlRequest) }
        request.progress?.resume()
    }

    /**
     Cancels given HTTP request.

     - Parameter request: An HttpRequest to cancel.
     */
    func cancel(_ request: HttpRequest) {
        activeSessions.forEach{ $0.value.cancel(request.urlRequest) }
        request.progress?.cancel()
    }

    ///Cancels all currently running HTTP requests.
    func cancelAllRequests() {
        activeSessions.forEach{ $0.value.cancelAllRequests() }
    }
}

private extension RequestService {

    ///Creates progress block for given request
    func progress(for request: HttpRequest) -> SessionServiceProgressHandler {
        return { (totalBytesProcessed, totalBytesExpectedToProcess) in
            request.progress?.completedUnitCount = totalBytesProcessed
            request.progress?.totalUnitCount = totalBytesExpectedToProcess
        }
    }

    ///Creates success block for given request
    func success(for request: HttpRequest) -> SessionServiceSuccessHandler {
        return { (response) in
            request.successAction?.perform(with: response)
        }
    }

    ///Creates success block for given download request
    func success(forDownload request: HttpDownloadRequest) -> SessionServiceSuccessHandler {
        return { [weak self] (response) in
            if let location = response.resourceUrl {
                if let error = self?.fileManager.copyFile(from: location, to: request.destinationUrl) {
                    request.failureAction?.perform(with: error)
                    return
                }
                response.update(with: request.destinationUrl)
            }
            request.successAction?.perform(with: response)
        }
    }

    ///Creates failure block for given request
    func failure(for request: HttpRequest) -> SessionServiceFailureHandler {
        return { (error) in
            request.failureAction?.perform(with: error)
        }
    }
}
