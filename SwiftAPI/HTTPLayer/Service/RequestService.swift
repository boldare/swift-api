//
//  APIRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

final class RequestService: NSObject {

    fileprivate var fileManager: FileManagerProtocol

    //MARK: - Handling multiple tasks
    private var currentTasks = [URLSessionTask: (request: HttpRequest, response: HttpResponse?)]()

    ///Sets request for current task
    func setCurrent(_ request: HttpRequest, for task: URLSessionTask) {
        currentTasks[task] = (request, nil)
    }

    ///Sets response for current task but only when request already exists
    fileprivate func setCurrent(_ response: HttpResponse, for task: URLSessionTask) -> Bool {
        guard var httpFunctions = currentTasks[task] else {
            debugPrint("Cannod add response when there is no request!")
            return false
        }
        httpFunctions.response = response
        currentTasks[task] = httpFunctions
        return true
    }

    ///Returns request for currently running task if exists.
    fileprivate func currentRequest(for task: URLSessionTask) -> HttpRequest? {
        return currentTasks[task]?.request
    }

    ///Returns response for currently running task if exists.
    fileprivate func currentResponse(for task: URLSessionTask) -> HttpResponse? {
        return currentTasks[task]?.response
    }

    ///Returns request and response for currently running task if exists.
    fileprivate func currentHttpFunctions(for task: URLSessionTask) -> (request: HttpRequest, response: HttpResponse?)? {
        return currentTasks[task]
    }

    ///Returns all currently running task with given request.
    fileprivate func currentTasks(for request: HttpRequest) -> [URLSessionTask] {
        return currentTasks.filter{ return $0.value.request == request }.flatMap({ return $0.key })
    }

    ///Returns all currently running task with given request.
    fileprivate var allCurrentTasks: [URLSessionTask] {
        return currentTasks.flatMap({ return $0.key })
    }

    ///Removes given task from queue.
    fileprivate func removeCurrent(_ task: URLSessionTask) {
        currentTasks.removeValue(forKey: task)

        //If there is no working task, we need to invalidate all sessions to break strong reference with delegate
        if currentTasks.isEmpty {
            for (_, session) in currentSessions {
                session.finishTasksAndInvalidate()
            }
            //After invalidation, session objects cannot be reused, so we can remove all sessions.
            currentSessions.removeAll()
        }
    }

    ///Removes all tasks from queue.
    fileprivate func cancelAllTasks() {
        for task in allCurrentTasks {
            task.cancel()
        }

        //If there is no working task, we need to invalidate all sessions to break strong reference with delegate
        for (_, session) in currentSessions {
            session.invalidateAndCancel()
        }
        //After invalidation, session objects cannot be reused, so we can remove all sessions.
        currentSessions.removeAll()
    }

    //MARK: - Handling multiple sessions
    private var currentSessions = [RequestServiceConfiguration : URLSession]()

    ///Returns URLSession for given configuration. If session does not exist, it creates one.
    fileprivate func currentSession(for configuration: RequestServiceConfiguration) -> URLSession {
        if let session = currentSessions[configuration] {
            return session
        }
        let session = URLSession(configuration: configuration.urlSessionConfiguration, delegate: self, delegateQueue: nil)
        currentSessions[configuration] = session
        return session
    }

    //MARK: - Handling background sessions
    ///Keeps completion handler for background sessions.
    fileprivate var backgroundSessionCompletionHandler = [String : () -> Void]()

    //MARK: Initialization
    ///Initializes service with given file manager.
    init(fileManager: FileManagerProtocol) {
        self.fileManager = fileManager
    }
}

//MARK: - Managing requests
extension RequestService {
    /**
     Sends given HTTP request.

     - Parameter request: An HttpDataRequest object provides request-specific information such as the URL, HTTP method or body data.
     
     HttpDataRequest may run only with foreground configuration.
     */
    func sendHTTPRequest(_ request: HttpDataRequest) {
        let session = currentSession(for: .foreground)
        let task = session.dataTask(with: request.urlRequest)
        setCurrent(request, for: task)
        task.resume()
    }

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpUploadRequest object provides request-specific information such as the URL, HTTP method or URL of the file to upload.
       - configuration: RequestServiceConfiguration indicates if request should be sent in foreground or background.
     */
    func sendHTTPRequest(_ request: HttpUploadRequest, in configuration: RequestServiceConfiguration = .background) {
        let session = currentSession(for: configuration)
        let task = session.uploadTask(with: request.urlRequest, fromFile: request.resourceUrl)
        setCurrent(request, for: task)
        task.resume()
    }

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpUploadRequest object provides request-specific information such as the URL, HTTP method or URL of the place on disc for downloading file.
       - configuration: RequestServiceConfiguration indicates if request should be sent in foreground or background.
     */
    func sendHTTPRequest(_ request: HttpDownloadRequest, in configuration: RequestServiceConfiguration = .background) {
        let session = currentSession(for: configuration)
        let task = session.downloadTask(with: request.urlRequest)
        setCurrent(request, for: task)
        task.resume()
    }

    /**
     Temporarily suspends given HTTP request.

     - Parameter request: An HttpUploadRequest to suspend.
     */
    func suspend(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.suspend()
        }
        request.progress?.pause()
    }

    /**
     Resumes given HTTP request, if it is suspended.

     - Parameter request: An HttpUploadRequest to resume.
     */
    func resume(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.resume()
        }
        if #available(iOS 9.0, *) {
            request.progress?.resume()
        } else {
            //TODO: Fallback on earlier versions
        }
    }

    /**
     Cancels given HTTP request.

     - Parameter request: An HttpUploadRequest to cancel.
     */
    func cancel(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.cancel()
        }
        request.progress?.cancel()
    }

    ///Cancels all currently running HTTP requests.
    func cancelAllRequests() {
        cancelAllTasks()
    }

    //MARK: - Handling background sessions
    /**
     Handle events for background session with identifier.

     - Parameters:
       - identifier: The identifier of the URL session requiring attention.
       - completionHandler: The completion handler to call when you finish processing the events.
     
     This method have to be used in `application(UIApplication, handleEventsForBackgroundURLSession: String, completionHandler: () -> Void)` method of AppDelegate.
     */
    func handleEventsForBackgroundSession(with identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler[identifier] = completionHandler
    }
}

extension RequestService: URLSessionDelegate {

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        //Informs that finishTasksAndInvalidate() or invalidateAndCancel() method was call on session object.
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        for (_, completionHandler) in backgroundSessionCompletionHandler {
            completionHandler()
        }
    }
}


extension RequestService: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let request = currentRequest(for: task) else {
            return
        }
        request.progress?.totalUnitCount = totalBytesExpectedToSend
        request.progress?.completedUnitCount = totalBytesSent
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let (request, response) = currentHttpFunctions(for: task) else {
            return
        }
        if let error = error ?? (response as? HttpFailureResponse)?.error {
            //Action should run on other thread to not block delegate.
            DispatchQueue.global(qos: .background).async {
                request.failureAction?.perform(with: error)
            }
        } else {
            if let taskResponse = task.response {
                response?.update(with: taskResponse)
            }
            //Action should run on other thread to not block delegate.
            DispatchQueue.global(qos: .background).async {
                request.successAction?.perform(with: response)
            }
        }
        removeCurrent(task)
    }
}

extension RequestService: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        var httpResponse: HttpResponse
        if let resp = currentResponse(for: dataTask) {
            httpResponse = resp
            httpResponse.update(with: response)
        } else {
            httpResponse = HttpResponse(urlResponse: response)
        }

        if setCurrent(httpResponse, for: dataTask) {
            completionHandler(.allow)
        } else {
            completionHandler(.cancel)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let response = currentResponse(for: dataTask) {
            response.appendBody(data)
        } else {
            let response = HttpResponse(body: data)
            _ = setCurrent(response, for: dataTask)
        }
    }
}

extension RequestService: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let (httpRequest, httpResponse) = currentHttpFunctions(for: downloadTask), let request = httpRequest as? HttpDownloadRequest else {
            return
        }

        var response: HttpResponse
        if let error = fileManager.copyFile(from: location, to: request.destinationUrl) {
            response = HttpFailureResponse(url: request.url, error: error)
        } else if let resp = httpResponse {
            response = resp
        } else {
            response = HttpResponse(resourceUrl: request.destinationUrl)
        }
        _ = setCurrent(response, for: downloadTask)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let request = currentRequest(for: downloadTask) else {
            return
        }
        request.progress?.totalUnitCount = totalBytesExpectedToWrite
        request.progress?.completedUnitCount = totalBytesWritten
    }
}
