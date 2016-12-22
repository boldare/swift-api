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

    private var currentRequests = [HttpRequest : [ResponseAction]]()

    fileprivate func currentRequest(with task: URLSessionTask) -> (HttpRequest, [ResponseAction])? {
        for (request, actions) in currentRequests {
            if request.task == task {
                return (request, actions)
            }
        }
        return nil
    }

    fileprivate func removeCurrentRequest(_ request: HttpRequest) {
        currentRequests.removeValue(forKey: request)
    }

    fileprivate func getActions(ofType type: ResponseAction, from actions: [ResponseAction]) -> [ResponseAction] {
        var specificActions = [ResponseAction]()
        for action in actions {
            if action.hasEqualType(with: type) {
                specificActions.append(action)
            }
        }
        return specificActions
    }

    func sendHTTPRequest(_ httpRequest: HttpRequest, actions: [ResponseAction]? = nil) {
        let task = defaultSession.dataTask(with: httpRequest.urlRequest)
        if let actions = actions {
            var request = httpRequest
            request.task = task
            currentRequests[request] = actions
        }
        task.resume()
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
        guard let (_, actions) = currentRequest(with: task)  else {
            return
        }
        for progress in getActions(ofType: .progress({_, _ in}), from: actions) {
            progress.perform(with: totalBytesSent, and: totalBytesExpectedToSend)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let (request, actions) = currentRequest(with: task)  else {
            return
        }
        if let error = error {
            for failure in getActions(ofType: .failure({_ in}), from: actions) {
                failure.perform(with: error)
            }
        }
        //Czy na pewno nic później się nie wywołuje?
        removeCurrentRequest(request)
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
