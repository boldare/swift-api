//
//  ApiManager.swift
//  Example
//
//  Created by Marek Kojder on 10.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

typealias ApiManagerCompletionHandler = (_ readableResponse: String?, _ resourceUrl: URL?, _ error: Error?) -> ()

struct ApiManager {

    func cancelAllRequests() {
        apiService.cancellAllRequests()
    }

    //MARK: Data requests
    func getRequest(completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("get")

        _ = apiService.get(from: url, completionHandler: completionHandler(for: completion))
    }

    func postRequest(completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("post")

        _ = apiService.post(data: exampleBody, at: url, with: exampleHeaders, completionHandler: completionHandler(for: completion))
    }

    func putRequest(completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("put")

        _ = apiService.put(data: exampleBody, at: url, with: exampleHeaders, completionHandler: completionHandler(for: completion))
    }

    func patchRequest(completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("patch")

        _ = apiService.patch(data: exampleBody, at: url, with: exampleHeaders, completionHandler: completionHandler(for: completion))
    }

    func deleteRequest(completion: @escaping ApiManagerCompletionHandler) {
        let url = apiRootURL.appendingPathComponent("delete")

        _ = apiService.delete(at: url, completionHandler: completionHandler(for: completion))
    }

    //MARK: Uploading files
    func postFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let destinationUrl = apiRootURL.appendingPathComponent("post")

        return apiService.postFile(from: fileToUpload(large: large), to: destinationUrl, inBackground: inBackground, completionHandler: completionHandler(for: completion)).progress
    }

    func putFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let destinationUrl = apiRootURL.appendingPathComponent("put")

        return apiService.putFile(from: fileToUpload(large: large), to: destinationUrl, inBackground: inBackground, completionHandler: completionHandler(for: completion)).progress
    }

    func patchFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let destinationUrl = apiRootURL.appendingPathComponent("patch")

        return apiService.patchFile(from: fileToUpload(large: large), to: destinationUrl, inBackground: inBackground, completionHandler: completionHandler(for: completion)).progress
    }

    //MARK: Downloading files
    func downloadFile(large: Bool, inBackground: Bool, completion: @escaping ApiManagerCompletionHandler) -> Progress? {
        let fileName = large ? "bigImage.jpg" : "smallImage.jpg"
        let destination = documentsUrl.appendingPathComponent(fileName)

        return apiService.download(from: fileToDownload(large: large), to: destination, inBackground: inBackground, completionHandler: completionHandler(for: completion)).progress
    }
}

fileprivate extension ApiManager {

    class Resources {
    }

    var apiService: ApiService {
        return (UIApplication.shared.delegate as! AppDelegate).apiService
    }

    var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    var apiRootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    var exampleBody: Data {
        let dictionary = ["Hello" : "World"]
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApiExample")]
    }

    func fileToUpload(large: Bool) -> URL {
        if large {
            return Bundle(for: ApiManager.Resources.self).url(forResource: "bigImage", withExtension: "jpg")!
        } else {
            return Bundle(for: ApiManager.Resources.self).url(forResource: "smallImage", withExtension: "jpg")!
        }
    }

    func fileToDownload(large: Bool) -> URL {
        if large {
            return URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg")!
        } else {
            return URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
        }
    }

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
