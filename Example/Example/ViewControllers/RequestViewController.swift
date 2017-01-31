//
//  RequestViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

class RequestViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getRequestButtonDidPush() {
        let url = apiRootURL.appendingPathComponent("get")

        textView.text = ""
        indicator.startAnimating()
        _ = apiService.get(from: url, completionHandler: completionHandler)
    }

    @IBAction func postRequestButtonDidPush() {
        let url = apiRootURL.appendingPathComponent("post")

        textView.text = ""
        indicator.startAnimating()
        _ = apiService.post(data: exampleBody, at: url, with: exampleHeaders, completionHandler: completionHandler)
    }

    @IBAction func putRequestButtonDidPush() {
        let url = apiRootURL.appendingPathComponent("put")

        textView.text = ""
        indicator.startAnimating()
        _ = apiService.put(data: exampleBody, at: url, with: exampleHeaders, completionHandler: completionHandler)
    }

    @IBAction func patchRequestButtonDidPush() {
        let url = apiRootURL.appendingPathComponent("patch")

        textView.text = ""
        indicator.startAnimating()
        _ = apiService.patch(data: exampleBody, at: url, with: exampleHeaders, completionHandler: completionHandler)
    }

    @IBAction func deleteRequestButtonDidPush() {
        let url = apiRootURL.appendingPathComponent("delete")

        textView.text = ""
        indicator.startAnimating()
        _ = apiService.delete(at: url, completionHandler: completionHandler)
    }
}

extension RequestViewController {

    fileprivate var apiService: ApiService {
        return (UIApplication.shared.delegate as! AppDelegate).apiService
    }

    fileprivate var apiRootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    fileprivate var exampleHeaders: [ApiHeader] {
        return [ApiHeader(name: "User-Agent", value: "SwiftApiExample")]
    }

    fileprivate var completionHandler: ApiResponseCompletionHandler {
        return {[weak self] (response: ApiResponse?, error: Error?) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    strongSelf.textView.text = "Error ocured during request:\n\(error.localizedDescription)"
                }
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
                DispatchQueue.main.async {
                    strongSelf.textView.text = readable
                }
            }
            DispatchQueue.main.async {
                strongSelf.indicator.stopAnimating()
            }
        }
    }

    fileprivate var exampleBody: Data {
        let dictionary = ["Hello" : "World"]
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)

    }
}
