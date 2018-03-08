//
//  SessionService.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 07.03.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

final class SessionService: NSObject {

    private(set) var isValid = true
    private let sessionQueue = DispatchQueue(label: "SwiftAPI.SessionService.sessionQueue", qos: .background)
    private var session: URLSession!
    private var activeCalls = [URLSessionTask: HttpCall]()

    private var invalidSessionError: Error {
        let description = "Attempted to create task in a session that has been invalidated."
        return NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: [NSLocalizedDescriptionKey : description])
    }

    private var lostReferenceError: Error {
        let description = "Lost reference to self."
        return NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: [NSLocalizedDescriptionKey : description])
    }

    init(configuration: RequestServiceConfiguration) {
        super.init()
        self.session = URLSession(configuration: configuration.urlSessionConfiguration, delegate: self, delegateQueue: nil)
    }

    deinit {
        session.invalidateAndCancel()
    }
}

extension SessionService {

    func data(request: URLRequest, progress: @escaping SessionServiceProgressHandler, success: @escaping SessionServiceSuccessHandler, failure: @escaping SessionServiceFailureHandler) {
        sessionQueue.sync { [weak self] in
            guard let strongSelf = self else {
                failure(invalidSessionError)
                return
            }
            guard strongSelf.isValid else {
                failure(lostReferenceError)
                return
            }
            let task = strongSelf.session.dataTask(with: request)
            strongSelf.activeCalls[task] = HttpCall(progressBlock: progress, successBlock: success, failureBlock: failure)
            DispatchQueue.global().async {
                task.resume()
            }
        }
    }

    func upload(request: URLRequest, file: URL, progress: @escaping SessionServiceProgressHandler, success: @escaping SessionServiceSuccessHandler, failure: @escaping SessionServiceFailureHandler) {
        sessionQueue.sync { [weak self] in
            guard let strongSelf = self else {
                failure(invalidSessionError)
                return
            }
            guard strongSelf.isValid else {
                failure(lostReferenceError)
                return
            }
            let task = strongSelf.session.uploadTask(with: request, fromFile: file)
            strongSelf.activeCalls[task] = HttpCall(progressBlock: progress, successBlock: success, failureBlock: failure)
            DispatchQueue.global().async {
                task.resume()
            }
        }
    }

    func download(request: URLRequest, progress: @escaping SessionServiceProgressHandler, success: @escaping SessionServiceSuccessHandler, failure: @escaping SessionServiceFailureHandler) {
        sessionQueue.sync { [weak self] in
            guard let strongSelf = self else {
                failure(invalidSessionError)
                return
            }
            guard strongSelf.isValid else {
                failure(lostReferenceError)
                return
            }
            let task = strongSelf.session.downloadTask(with: request)
            strongSelf.activeCalls[task] = HttpCall(progressBlock: progress, successBlock: success, failureBlock: failure)
            DispatchQueue.global().async {
                task.resume()
            }
        }
    }

    func suspend(_ request: URLRequest) {
        activeCalls.forEach { (task, _) in
            guard task.currentRequest == request else { return }
            task.suspend()
        }
    }

    @available(iOS 9.0, OSX 10.11, *)
    func resume(_ request: URLRequest) {
        activeCalls.forEach { (task, _) in
            guard task.currentRequest == request else { return }
            task.resume()
        }
    }

    func cancel(_ request: URLRequest) {
        activeCalls.forEach { (task, _) in
            guard task.currentRequest == request else { return }
            task.cancel()
        }
    }

    func cancelAllRequests() {
        activeCalls.forEach { $0.key.cancel() }
    }

    func invalidateAndCancel() {
        sessionQueue.sync { [weak self] in
            self?.isValid = false
            self?.session.invalidateAndCancel()
        }
    }
}

extension SessionService: URLSessionDelegate {

    //Informs that finishTasksAndInvalidate() or invalidateAndCancel() method was call on session object.
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionQueue.sync { [weak self] in
            self?.isValid = false
        }
    }
}

extension SessionService: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        activeCalls[task]?.performProgress(totalBytesProcessed: totalBytesSent, totalBytesExpectedToProcess: totalBytesExpectedToSend)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let call = activeCalls[task] else { return }
        guard let taskResponse = task.response else {
            call.performFailure(with: error)
            return
        }
        call.update(with: taskResponse)
        guard let response = call.response else {
            call.performFailure(with: error)
            return
        }
        call.performSuccess(with: response)
        activeCalls.removeValue(forKey: task)
    }
}

extension SessionService: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler completion: @escaping (URLSession.ResponseDisposition) -> Void) {
        activeCalls[dataTask]?.update(with: response)
        activeCalls[dataTask] != nil ? completion(.allow) : completion(.cancel)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        activeCalls[dataTask]?.update(with: data)
    }
}

extension SessionService: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        activeCalls[downloadTask]?.update(with: location)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        activeCalls[downloadTask]?.performProgress(totalBytesProcessed: totalBytesWritten, totalBytesExpectedToProcess: totalBytesExpectedToWrite)
    }
}
