//
//  RootViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

class UploadViewController: UIViewController {

    @IBOutlet var largeImageSwitch: UISwitch!
    @IBOutlet var backgroundSwitch: UISwitch!
    @IBOutlet var textView: UITextView!
    @IBOutlet var progressBar: UIProgressView!

    fileprivate var progress = Progress(totalUnitCount: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = ""
        progressBar.progress = 0.0
        progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        progress.removeObserver(self, forKeyPath: "fractionCompleted")
    }

    func prepareForRequest() {
        textView.text = ""
    }

    func startProgress(with request: ApiRequest) {
        if let p = request.progress {
            progress.totalUnitCount += 1
            progress.addChild(p, withPendingUnitCount: 1)
        }
        progressBar.progress = Float(progress.fractionCompleted)
    }

    func reserProgress() {
        progress.removeObserver(self, forKeyPath: "fractionCompleted")
        progress = Progress(totalUnitCount: 0)
        progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
    }

    @IBAction func postRequestButtonDidPush() {
        let destinationUrl = apiRootURL.appendingPathComponent("post")

        prepareForRequest()
        let request = apiService.postFile(from: fileToUpload, to: destinationUrl, inBackground: backgroundSwitch.isOn, completionHandler: completionHandler)
        startProgress(with: request)
    }

    @IBAction func putRequestButtonDidPush() {
        let destinationUrl = apiRootURL.appendingPathComponent("put")

        prepareForRequest()
        let request = apiService.putFile(from: fileToUpload, to: destinationUrl, inBackground: backgroundSwitch.isOn, completionHandler: completionHandler)
        startProgress(with: request)
    }

    @IBAction func patchRequestButtonDidPush() {
        let destinationUrl = apiRootURL.appendingPathComponent("patch")

        prepareForRequest()
        let request = apiService.patchFile(from: fileToUpload, to: destinationUrl, inBackground: backgroundSwitch.isOn, completionHandler: completionHandler)
        startProgress(with: request)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted", let p = object as? Progress {
            DispatchQueue.main.async {
                self.progressBar.progress = Float(p.fractionCompleted)
            }
        }
    }
}

fileprivate extension UploadViewController {

    var apiService: ApiService {
        return (UIApplication.shared.delegate as! AppDelegate).apiService
    }

    var apiRootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    var smallLocalFileURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "smallImage", withExtension: "jpg")!
    }

    var bigLocalFileURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "bigImage", withExtension: "jpg")!
    }

    var fileToUpload: URL {
        if largeImageSwitch.isOn {
            return bigLocalFileURL
        } else {
            return smallLocalFileURL
        }
    }

    var completionHandler: ApiResponseCompletionHandler {
        return {[weak self] (response: ApiResponse?, error: Error?) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.progress.completedUnitCount == strongSelf.progress.totalUnitCount {
                strongSelf.reserProgress()
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
                    strongSelf.textView.setContentOffset(.zero, animated: false)
                }
            }
        }
    }
}
