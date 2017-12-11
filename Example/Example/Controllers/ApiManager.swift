//
//  ApiManager.swift
//  Example
//
//  Created by Marek Kojder on 10.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

///Completion type for all requests.
typealias ApiManagerCompletionHandler = (_ readableResponse: String?, _ resourceUrl: URL?, _ error: Error?) -> ()

struct ApiManager {

    ///ApiService for request managing.
    fileprivate let apiService = ApiService()

    ///Cancels all currently running requests.
    func cancelAllRequests() {
        apiService.cancelAllRequests()
    }

    ///Method to run in *AppDelegate* to manage background tasks
    func handleEventsForBackgroundSession(with identifier: String, completionHandler: @escaping () -> Void) {
        apiService.handleEventsForBackgroundSession(with: identifier, completion: completionHandler)
    }

    //MARK: Data requests
    ///Performs GET request.
    func getRequest(_ completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("get")

        _ = apiService.getData(from: url, completion: completionHandler(for: completion))
    }

    ///Performs POST request.
    func postRequest(_ completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("post")

        _ = apiService.post(data: exampleBody, at: url, with: exampleHeaders, completion: completionHandler(for: completion))
    }

    ///Performs PUT request.
    func putRequest(_ completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("put")

        _ = apiService.put(data: exampleBody, at: url, with: exampleHeaders, completion: completionHandler(for: completion))
    }

    ///Performs PATCH request.
    func patchRequest(_ completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("patch")

        _ = apiService.patch(data: exampleBody, at: url, with: exampleHeaders, completion: completionHandler(for: completion))
    }

    ///Performs DELETE request.
    func deleteRequest(_ completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("delete")

        _ = apiService.delete(at: url, completion: completionHandler(for: completion))
    }

    ///Perform custom request
    func customRequest(_ completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("get")

        _ = apiService.performRequest(to: url, with: .get, configuration: customConfiguration, completion: completionHandler(for: completion))
    }

    //MARK: Uploading files
    ///Sends file using POST request.
    func postFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let destinationUrl = apiRootURL.appendingPathComponent("post")

        return apiService.postFile(from: fileToUpload(large: large), to: destinationUrl, inBackground: inBackground, completion: completionHandler(for: completion)).progress
    }

    ///Sends file using PUT request.
    func putFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let destinationUrl = apiRootURL.appendingPathComponent("put")

        return apiService.putFile(from: fileToUpload(large: large), to: destinationUrl, inBackground: inBackground, completion: completionHandler(for: completion)).progress
    }

    ///Sends file using PATCH request.
    func patchFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let destinationUrl = apiRootURL.appendingPathComponent("patch")

        return apiService.patchFile(from: fileToUpload(large: large), to: destinationUrl, inBackground: inBackground, completion: completionHandler(for: completion)).progress
    }

    ///Sends file using custom request.
    func customUploadFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let destinationUrl = apiRootURL.appendingPathComponent("put")

        return apiService.uploadFile(from: fileToUpload(large: large), to: destinationUrl, with: .put, configuration: customConfiguration, completion:  completionHandler(for: completion)).progress
    }

    //MARK: Downloading files
    ///Downloads file.
    func downloadFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {

        return apiService.downloadFile(from: fileToDownload(large: large), to: downloadedFileURL(large: large), inBackground: inBackground, completion: completionHandler(for: completion)).progress
    }

    ///Downloads file using custom request.
    func customDownloadFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {

        return apiService.downloadFile(from: fileToDownload(large: large), to: downloadedFileURL(large: large), configuration: customConfiguration, completion: completionHandler(for: completion)).progress
    }
}

//MARK: Private helpers
fileprivate extension ApiManager {

    private class Resources {}

    ///URL of documents directory.
    var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    ///Root URL of API.
    var apiRootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    ///Example HTTP header.
    var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApiExample")]
    }

    ///Example custom configuration
    var customConfiguration: RequestServiceConfiguration {
        let sessionConfigutration = URLSessionConfiguration.default
        sessionConfigutration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        sessionConfigutration.timeoutIntervalForRequest = 100
        sessionConfigutration.timeoutIntervalForResource = 3600

        return RequestServiceConfiguration.custom(with: sessionConfigutration)
    }

    ///Example JSON body converted to *Data* object.
    var exampleBody: Data {
        let dictionary = ["Hello" : "World"]
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    ///URL of file to upload.
    func fileToUpload(large: Bool) -> URL {
        if large {
            return Bundle(for: ApiManager.Resources.self).url(forResource: "bigImage", withExtension: "jpg")!
        } else {
            return Bundle(for: ApiManager.Resources.self).url(forResource: "smallImage", withExtension: "jpg")!
        }
    }

    ///URL of file to download.
    func fileToDownload(large: Bool) -> URL {
        if large {
            return URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg")!
        } else {
            return URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
        }
    }

    ///Place  where file should be saved after downloading.
    func downloadedFileURL(large: Bool) -> URL {
        return documentsUrl.appendingPathComponent(large ? "bigImage.jpg" : "smallImage.jpg")
    }

    ///Completion handler for all api requests.
    func completionHandler(for completion: @escaping ApiManagerCompletionHandler) -> ApiResponseCompletionHandler {
        return { (response: ApiResponse?, error: Error?) in
            if let error = error {
                completion(nil, nil, error)
            } else if let response = response {
                var readable = ""
                if let url = response.url {
                    readable.append("URL: \(url)\n")
                }
                readable.append("Status code: \(response.statusCode.rawValue) \(response.statusCode.description)\n")
                if let mime = response.mimeType {
                    readable.append("MIME Type: \(mime)\n")
                }
                if let headers = response.allHeaderFields {
                    readable.append("Headers:\n")
                    for header in headers {
                        readable.append("   \(header.key) : \(header.value)\n")
                    }
                }
                if let body = response.body, let json = String(data: body, encoding: .utf8){
                    readable.append("Body:\n")
                    readable.append(json)
                }
                completion(readable, response.resourceUrl, nil)
            } else {
                completion("This should not happen!", nil, nil)
            }
        }
    }
}
