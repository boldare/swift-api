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

    func sendHTTPRequest(_ request: HttpRequest, actions: [ResponseAction]? = nil) {
        var successes = [ResponseAction]()
        var failures = [ResponseAction]()
        var progresses = [ResponseAction]()

        if let actions = actions {
            for action in actions {
                switch action {
                case .success:
                    successes.append(action)
                case .failure:
                    failures.append(action)
                case .progress:
                    progresses.append(action)
                }
            }
        }
        defaultSession.dataTask(with: request.urlRequest).resume()
    }
}

extension Webservice: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {

    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
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

fileprivate extension HttpRequest {

    var urlRequest: URLRequest {
        var url = baseUrl
        if let path = path {
            url.appendPathComponent(path)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        request.httpBody = httpBody
        return request
    }
}
