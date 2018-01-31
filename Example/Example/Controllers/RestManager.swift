//
//  RestManager.swift
//  Example
//
//  Created by Marek Kojder on 10.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

struct ResponseData: Codable {

    enum CodingKeys: String, CodingKey {
        case origin
        case url
        case data
    }

    let origin: String
    let url: URL
    let data: RequestData?

    var readableDescription: String {
        var general = "origin: \(origin)\nurl: \(url.absoluteString)"
        if let data = data {
            general.append("\ndata:\n   value1: \(data.value1)\n   value2: \(data.value2)")
        }
        return general
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        origin = try container.decode(String.self, forKey: .origin)
        url = try container.decode(URL.self, forKey: .url)
        if let dataString = try? container.decode(String.self, forKey: .data), let data = dataString.data(using: .utf8) {
            self.data = try? JSONDecoder().decode(RequestData.self, from: data)
        } else {
            self.data = nil
        }
    }
}

struct RequestData: Codable {
    let value1: String
    let value2: String
}

private enum Path: String, ResourcePath {
    case get
    case post
    case patch
    case put
    case delete

    case largeFileToDownload = "wikipedia/commons/3/3f/Fronalpstock_big.jpg"
    case smallFileToDownload = "wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg"
}

///Completion type for data requests.
typealias RestManagerCompletionHandler = (_ response: ResponseData?, _ readableError: String?) -> ()

///Completion type for file requests.
typealias RestManagerFileCompletionHandler = (_ fileUrl: URL?, _ readableError: String?) -> ()

struct RestManager {

    ///RestService for request managing.
    fileprivate let restService: RestService

    init(forFileDownload: Bool) {
        let rootURL: URL
        let apiPath = ""
        let headers: [ApiHeader]?
        if forFileDownload {
            rootURL = URL(string: "https://upload.wikimedia.org/")!
            headers = nil
        } else {
            rootURL = URL(string: "https://httpbin.org")!
            headers = [ApiHeader(name: "User-Agent", value: "SwiftApiExample")]
        }
        self.restService = RestService(baseUrl: rootURL, apiPath: apiPath, headerFields: headers)
    }

    ///Cancels all currently running requests.
    func cancelAllRequests() {
        restService.cancelAllRequests()
    }

    ///Method to run in *AppDelegate* to manage background tasks
    func handleEventsForBackgroundSession(with identifier: String, completionHandler: @escaping () -> Void) {
        restService.handleEventsForBackgroundSession(with: identifier, completion: completionHandler)
    }

    //MARK: Data requests
    ///Performs GET request.
    func getResource(_ completion: @escaping RestManagerCompletionHandler) {
        restService.get(type: ResponseData.self, from: Path.get, with: authHeader, completion: completionHandler(for: completion))
    }

    ///Performs POST request.
    func postResource(_ completion: @escaping RestManagerCompletionHandler) {
        restService.post(exampleData, at: Path.post, aditionalHeaders: authHeader, responseType: ResponseData.self, completion: completionHandler(for: completion))
    }

    ///Performs PUT request.
    func putResource(_ completion: @escaping RestManagerCompletionHandler) {
        restService.put(exampleData, at: Path.put, aditionalHeaders: authHeader, responseType: ResponseData.self, completion: completionHandler(for: completion))
    }

    ///Performs PATCH request.
    func patchResource(_ completion: @escaping RestManagerCompletionHandler) {
        restService.patch(exampleData, at: Path.patch, aditionalHeaders: authHeader, responseType: ResponseData.self, completion: completionHandler(for: completion))
    }

    ///Performs DELETE request.
    func deleteResource(_ completion: @escaping RestManagerCompletionHandler) {
        restService.delete(exampleData, at: Path.delete, aditionalHeaders: authHeader, responseType: ResponseData.self, completion: completionHandler(for: completion))
    }

    //MARK: Downloading files
    ///Downloads file using GET request.
    func getFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let path = fileToDownload(large: large)
        let location = downloadedFileURL(large: large)
        let completion = completionHandler(for: location, with: completion)
        return restService.getFile(at: path, saveAt: location, inBackground: inBackground, completion: completion).progress
    }

    //MARK: Uploading files
    ///Sends file using POST request.
    func postFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let location = fileToUpload(large: large)
        let completion = completionHandler(for: location, with: completion)
        return restService.postFile(from: location, at: Path.post, inBackground: inBackground, completion: completion).progress
    }

    ///Sends file using PUT request.
    func putFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let location = fileToUpload(large: large)
        let completion = completionHandler(for: location, with: completion)
        return restService.putFile(from: location, at: Path.put, inBackground: inBackground, completion: completion).progress
    }

    ///Sends file using PATCH request.
    func patchFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let location = fileToUpload(large: large)
        let completion = completionHandler(for: location, with: completion)
        return restService.patchFile(from: location, at: Path.patch, inBackground: inBackground, completion: completion).progress
    }
}


//MARK: Private helpers
fileprivate extension RestManager {

    private class Resources {}

    ///URL of documents directory.
    private var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    ///Example Basic Auth header.
    var authHeader: [ApiHeader]? {
        if let header = ApiHeader(login: "admin", password: "admin1") {
            return [header]
        }
        return nil
    }

    ///Example data to send.
    var exampleData: RequestData {
        return RequestData(value1: "1", value2: "2")
    }

    ///URL of file to upload.
    func fileToUpload(large: Bool) -> URL {
        if large {
            return Bundle(for: RestManager.Resources.self).url(forResource: "bigImage", withExtension: "jpg")!
        } else {
            return Bundle(for: RestManager.Resources.self).url(forResource: "smallImage", withExtension: "jpg")!
        }
    }

    ///Path of file to download.
    func fileToDownload(large: Bool) -> Path {
        return large ? .largeFileToDownload : .smallFileToDownload
    }

    ///Place  where file should be saved after downloading.
    func downloadedFileURL(large: Bool) -> URL {
        return documentsUrl.appendingPathComponent(large ? "bigImage.jpg" : "smallImage.jpg")
    }

    ///Completion handler for data requests.
    func completionHandler(for completion: @escaping RestManagerCompletionHandler) -> RestResponseCompletionHandler<ResponseData> {
        return { (data: ResponseData?, error: Error?) in
            guard let data = data, error == nil else {
                let readableError: String
                if let error = error {
                    readableError = "Error occured during request:\n \(error.localizedDescription)"
                } else {
                    readableError = "Unknown error occured during request."
                }
                completion(nil, readableError)
                return
            }
            completion(data, nil)
        }
    }

    ///Completion handler for file requests.
    func completionHandler(for fileUrl: URL, with completion: @escaping RestManagerFileCompletionHandler) -> RestSimpleResponseCompletionHandler {
        return { (success: Bool, error: Error?) in
            guard success == true, error == nil else {
                let readableError: String
                if let error = error {
                    readableError = "Error occured during request:\n \(error.localizedDescription)"
                } else {
                    readableError = "Unknown error occured during request."
                }
                completion(nil, readableError)
                return
            }
            completion(fileUrl, nil)
        }
    }
}
