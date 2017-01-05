//
//  APIRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

final class RequestService: NSObject {

    //MARK: - Handling multiple tasks

    private var currentTasks = [URLSessionTask: HttpRequest]()

    fileprivate func currentRequest(for task: URLSessionTask) -> HttpRequest? {
        return currentTasks[task]
    }

    fileprivate func currentTasks(for request: HttpRequest) -> [URLSessionTask] {
        return currentTasks.filter{ return $0.1 == request }.flatMap({ return $0.0 })
    }

    fileprivate func removeCurrentTask(_ task: URLSessionTask) {
        currentTasks.removeValue(forKey: task)
    }

    //MARK: - Handling multiple sessions

    private var currentSessions = [RequestServiceConfiguration : URLSession]()

    fileprivate func currentSession(for configuration: RequestServiceConfiguration) -> URLSession {
        if let session = currentSessions[configuration] {
            return session
        }
        let session = URLSession(configuration: configuration.urlSessionConfiguration, delegate: self, delegateQueue: nil)
        currentSessions[configuration] = session
        return session
    }

    //MARK: - Managing requests

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpDataRequest object provides request-specific information such as the URL, HTTP method or body data.
       - configuration: RequestServiceConfiguration indicates if request should be sent in foreground or background.
     */
    func sendHTTPRequest(_ request: HttpDataRequest, with configuration: RequestServiceConfiguration = .foreground) {
        let session = currentSession(for: configuration)
        let task = session.dataTask(with: request.urlRequest)
        currentTasks[task] = request
        task.resume()
    }

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpUploadRequest object provides request-specific information such as the URL, HTTP method or URL of the file to upload.
       - configuration: RequestServiceConfiguration indicates if request should be sent in foreground or background.
     */
    func sendHTTPRequest(_ request: HttpUploadRequest, with configuration: RequestServiceConfiguration = .background) {
        let session = currentSession(for: configuration)
        let task = session.uploadTask(with: request.urlRequest, fromFile: request.resourceUrl)
        currentTasks[task] = request
        task.resume()
    }

    /**
     Sends given HTTP request.

     - Parameters:
       - request: An HttpUploadRequest object provides request-specific information such as the URL, HTTP method or URL of the place on disc for downloading file.
       - configuration: RequestServiceConfiguration indicates if request should be sent in foreground or background.
     */
    func sendHTTPRequest(_ request: HttpDownloadRequest, with configuration: RequestServiceConfiguration = .background) {
        let session = currentSession(for: configuration)
        let task = session.downloadTask(with: request.urlRequest)
        currentTasks[task] = request
        task.resume()
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
            // Fallback on earlier versions
        }
    }
}

extension RequestService: URLSessionDelegate {

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
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
        guard let request = currentRequest(for: task) else {
            return
        }
        if let error = error, let failure = request.failureAction {
            failure.perform(with: error)
        }
        //Jeśli nie ma błędu zakońćzył sie sukcesem
        removeCurrentTask(task)
    }
}

extension RequestService: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        //Tutaj trzeba by zapisać jakoś nagłówki.
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    }
}

extension RequestService: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let request = currentRequest(for: downloadTask) else {
            return
        }
        request.progress?.totalUnitCount = totalBytesExpectedToWrite
        request.progress?.completedUnitCount = totalBytesWritten
    }
}
