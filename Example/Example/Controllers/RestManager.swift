//
//  RestManager.swift
//  Example
//
//  Created by Marek Kojder on 10.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

///Example resource implementing *RestDataResource* protocol.
struct SimpleDataResource: RestDataResource {

    let name: String
    let title: String

    private(set) var readableDescription: String

    init(name: String, title: String = "") {
        self.name = name
        self.title = title
        self.readableDescription = ""
    }

    var data: Data? {
        let dictionary = ["title" : title]
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    mutating func update(with responseData: Data?, aditionalInfo: [RestResponseHeader]? ) -> Error? {
        readableDescription = ""
        if let headers = aditionalInfo {
            readableDescription.append("Aditional info:\n")
            for header in headers {
                readableDescription.append("   \(header.name) : \(header.value)\n")
            }
        }
        if let data = responseData, let json = String(data: data, encoding: .utf8){
            readableDescription.append("Data:\n\(json)")
        }
        return nil
    }
}

///Example resource implementing *RestFileResource* protocol.
struct SimpleFileResource: RestFileResource {

    let name: String
    let location: URL

    private(set) var readableDescription: String
    
    init(name: String, location: URL) {
        self.name = name
        self.location = location
        self.readableDescription = ""
    }

    mutating func update(with aditionalInfo: [RestResponseHeader]?) -> Error? {
        readableDescription = ""
        if let headers = aditionalInfo {
            readableDescription.append("Aditional info:\n")
            for header in headers {
                readableDescription.append("   \(header.name) : \(header.value)\n")
            }
        }
        readableDescription.append("File URL:\n\(location.path)")
        return nil
    }
}

///Completion type for data requests.
typealias RestManagerSimpleCompletionHandler = (_ resource: SimpleDataResource?, _ readableError: String?) -> ()

///Completion type for file requests.
typealias RestManagerFileCompletionHandler = (_ resource: SimpleFileResource?, _ readableError: String?) -> ()

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
        self.restService = RestService(baseUrl: rootURL, apiPath: apiPath, headerFields: headers, fileManager: FileCommander())
    }

    ///Cancels all currently running requests.
    func cancelAllRequests() {
        restService.cancelAllRequests()
    }

    ///Method to run in *AppDelegate* to manage background tasks
    func handleEventsForBackgroundSession(with identifier: String, completionHandler: @escaping () -> Void) {
        restService.handleEventsForBackgroundSession(with: identifier, completionHandler: completionHandler)
    }

    //MARK: Data requests
    ///Performs GET request.
    func getResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleDataResource(name: "get")
        _ = restService.get(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    ///Performs POST request.
    func postResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleDataResource(name: "post")
        _ = restService.post(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    ///Performs PUT request.
    func putResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleDataResource(name: "put")
        _ = restService.put(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    ///Performs PATCH request.
    func patchResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleDataResource(name: "patch")
        _ = restService.patch(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    ///Performs DELETE request.
    func deleteResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleDataResource(name: "delete")
        _ = restService.delete(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    //MARK: Downloading files
    ///DOwnloads file using GET request.
    func getFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = SimpleFileResource(name: fileToDownload(large: large), location: downloadedFileURL(large: large))
        return restService.getFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
    }

    //MARK: Uploading files
    ///Sends file using POST request.
    func postFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = SimpleFileResource(name: "post", location: fileToUpload(large: large))
        return restService.postFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
    }

    ///Sends file using PUT request.
    func putFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = SimpleFileResource(name: "put", location: fileToUpload(large: large))
        return restService.putFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
    }

    ///Sends file using PATCH request.
    func patchFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = SimpleFileResource(name: "patch", location: fileToUpload(large: large))
        return restService.patchFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
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

    ///URL of file to upload.
    func fileToUpload(large: Bool) -> URL {
        if large {
            return Bundle(for: RestManager.Resources.self).url(forResource: "bigImage", withExtension: "jpg")!
        } else {
            return Bundle(for: RestManager.Resources.self).url(forResource: "smallImage", withExtension: "jpg")!
        }
    }

    ///Path of file to download.
    func fileToDownload(large: Bool) -> String {
        if large {
            return "wikipedia/commons/3/3f/Fronalpstock_big.jpg"
        } else {
            return "wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg"
        }
    }

    ///Place  where file should be saved after downloading.
    func downloadedFileURL(large: Bool) -> URL {
        return documentsUrl.appendingPathComponent(large ? "bigImage.jpg" : "smallImage.jpg")
    }

    ///Completion handler for data requests.
    func simpleCompletionHandler(for completion: @escaping RestManagerSimpleCompletionHandler) -> RestDataResponseCompletionHandler {
        return { (resource: RestResource, error: RestErrorResponse?) in
            if let error = error {
                var readableError = "Error occured during request:\n \(error.error.localizedDescription)"
                if let headers = error.aditionalInfo {
                    readableError.append("Aditional info:\n")
                    for header in headers {
                        readableError.append("   \(header.name) : \(header.value)\n")
                    }
                }
                if let data = error.body, let json = String(data: data, encoding: .utf8){
                    readableError.append("Data:\n\(json)")
                }
                completion(nil, readableError)
            } else if let resource = resource as? SimpleDataResource {
                completion(resource, nil)
            } else {
                completion(nil, "This should not happen!")
            }
        }
    }

    ///Completion handler for file requests.
    func fileCompletionHandler(for completion: @escaping RestManagerFileCompletionHandler) -> RestFileResponseCompletionHandler {
        return { (resource: RestFileResource, error: RestErrorResponse?) in
            if let error = error {
                var readableError = "Error occured during request:\n \(error.error.localizedDescription)"
                if let headers = error.aditionalInfo {
                    readableError.append("Aditional info:\n")
                    for header in headers {
                        readableError.append("   \(header.name) : \(header.value)\n")
                    }
                }
                if let data = error.body, let json = String(data: data, encoding: .utf8){
                    readableError.append("Data:\n\(json)")
                }
                completion(nil, readableError)
            } else if let resource = resource as? SimpleFileResource {
                completion(resource, nil)
            } else {
                completion(nil, "This should not happen!")
            }
        }
    }
}
