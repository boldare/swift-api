//
//  APIRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

final class RequestService: NSObject {

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

    func sendHTTPRequest(_ request: HttpDataRequest, in session: RequestServiceSession = .foreground) {
        let task = session.session.dataTask(with: request.urlRequest)
        currentTasks[task] = request
        task.resume()
    }

    func sendHTTPRequest(_ request: HttpUploadRequest, in session: RequestServiceSession = .background) {
        let task = session.session.uploadTask(with: request.urlRequest, fromFile: request.resourceUrl)
        currentTasks[task] = request
        task.resume()
    }

    func sendHTTPRequest(_ request: HttpDownloadRequest, in session: RequestServiceSession = .background) {
        let task = session.session.downloadTask(with: request.urlRequest)
        currentTasks[task] = request
        task.resume()
    }

    func cancel(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.cancel()
        }
        request.progress?.cancel()
    }

    func suspend(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.suspend()
        }
        request.progress?.pause()
    }

    func resume(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.resume()
        }
        request.progress?.resume()
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
        //Czy na pewno nic później się nie wywołuje?
        removeCurrentTask(task)
    }
}

extension RequestService: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
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
