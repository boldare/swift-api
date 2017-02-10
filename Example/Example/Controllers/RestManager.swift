//
//  RestManager.swift
//  Example
//
//  Created by Marek Kojder on 10.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

typealias RestManagerSimpleCompletionHandler = (_ resource: SimpleResource?, _ readableError: String?) -> ()
typealias RestManagerFileCompletionHandler = (_ resource: FileResource?, _ readableError: String?) -> ()

struct SimpleResource: RestResource {

    let name: String
    let title: String

    private(set) var readableDescription: String

    init(name: String, title: String = "") {
        self.name = name
        self.title = title
        self.readableDescription = ""
    }

    var dataRepresentation: Data? {
        let dictionary = ["title" : title]
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    mutating func updateWith(responseData: Data?, aditionalInfo: [RestResponseHeader]? ) -> Error? {
        var readableDescription = ""
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

struct FileResource: RestFileResource {

    let name: String
    let location: URL

    init(name: String, location: URL) {
        self.name = name
        self.location = location
    }
}

struct RestManager {

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

    func cancelAllRequests() {
        restService.cancelAllRequests()
    }

    func handleEventsForBackgroundSession(with identifier: String, completionHandler: @escaping () -> Void) {
        restService.handleEventsForBackgroundSession(with: identifier, completionHandler: completionHandler)
    }

    //MARK: Data requests
    func getResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleResource(name: "get")
        _ = restService.get(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    func postResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleResource(name: "post")
        _ = restService.get(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    func putResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleResource(name: "put")
        _ = restService.get(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    func patchResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleResource(name: "patch")
        _ = restService.get(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    func deleteResource(_ completion: @escaping RestManagerSimpleCompletionHandler) {
        let resource = SimpleResource(name: "delete")
        _ = restService.get(resource: resource, aditionalHeaders: authHeader, completion: simpleCompletionHandler(for: completion))
    }

    //MARK: Downloading files
    func getFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = FileResource(name: "wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg", location: downloadedFileURL(large: large))
        return restService.getFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
    }

        //MARK: Uploading files
    func postFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = FileResource(name: "post", location: fileToUpload(large: large))
        return restService.getFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
    }

    func putFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = FileResource(name: "put", location: fileToUpload(large: large))
        return restService.getFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
    }

    func patchFile(large: Bool, inBackground: Bool, completion: @escaping RestManagerFileCompletionHandler) -> Progress? {
        let resource = FileResource(name: "patch", location: fileToUpload(large: large))
        return restService.getFile(resource: resource, inBackground: inBackground, completion: fileCompletionHandler(for: completion)).progress
    }
}

fileprivate extension RestManager {

    private class Resources {
    }

    var authHeader: [ApiHeader]? {
        if let header = ApiHeader(login: "admin", password: "admin1") {
            return [header]
        }
        return nil
    }

    private var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    func downloadedFileURL(large: Bool) -> URL {
        return documentsUrl.appendingPathComponent(large ? "bigImage.jpg" : "smallImage.jpg")
    }

    func fileToUpload(large: Bool) -> URL {
        if large {
            return Bundle(for: RestManager.Resources.self).url(forResource: "bigImage", withExtension: "jpg")!
        } else {
            return Bundle(for: RestManager.Resources.self).url(forResource: "smallImage", withExtension: "jpg")!
        }
    }

    func simpleCompletionHandler(for completion: @escaping RestManagerSimpleCompletionHandler) -> RestResponseCompletionHandler {
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
            } else if let resource = resource as? SimpleResource {
                completion(resource, nil)
            } else {
                completion(nil, "This should not happen!")
            }
        }
    }

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
            } else if let resource = resource as? FileResource {
                completion(resource, nil)
            } else {
                completion(nil, "This should not happen!")
            }
        }
    }
}
