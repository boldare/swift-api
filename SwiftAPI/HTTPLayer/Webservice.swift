//
//  APIRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

final class Webservice: NSObject {

    private var defaultSession: URLSession {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }

    private var backgroundSession: URLSession {
        let config = URLSessionConfiguration.background(withIdentifier: "temp")
        return URLSession(configuration: config)
    }

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

    func sendHTTPRequest(_ httpRequest: HttpRequest) {
        let task = defaultSession.dataTask(with: httpRequest.urlRequest)
        currentTasks[task] = httpRequest
        task.resume()
    }

    func cancel(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.cancel()
        }
    }

    func suspend(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.suspend()
        }
    }

    func resume(_ request: HttpRequest) {
        for task in currentTasks(for: request) {
            task.resume()
        }
    }
}

extension Webservice: URLSessionDelegate {

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    }
}


extension Webservice: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let request = currentRequest(for: task) else {
            return
        }
        if let progress = request.onProgress {
            progress.perform(with: totalBytesSent, and: totalBytesExpectedToSend)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let request = currentRequest(for: task) else {
            return
        }
        if let error = error, let failure = request.onFailure {
            failure.perform(with: error)
        }
        //Czy na pewno nic później się nie wywołuje?
        removeCurrentTask(task)
    }
}

extension Webservice: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    }
    
}

extension Webservice: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    }
}
