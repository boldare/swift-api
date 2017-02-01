//
//  DownloadViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

class DownloadViewController: UIViewController {

    @IBOutlet var largeImageSwitch: UISwitch!
    @IBOutlet var backgroundSwitch: UISwitch!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!

    fileprivate var progress = Progress(totalUnitCount: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = nil
        textView.text = ""
        progressBar.progress = 0.0
        progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        progress.removeObserver(self, forKeyPath: "fractionCompleted")
        apiService.cancellAllRequests()
    }

    func prepareForRequest() {
        imageView.image = nil
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

    @IBAction func requestButtonDidPush() {
        let fileName = largeImageSwitch.isOn ? "bigImage.jpg" : "smallImage.jpg"
        let destination = documentsUrl.appendingPathComponent(fileName)

        prepareForRequest()
        let request = apiService.download(from: fileToDownload, to: destination, inBackground: backgroundSwitch.isOn, completionHandler: completionHandler)
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

fileprivate extension DownloadViewController {

    var apiService: ApiService {
        return (UIApplication.shared.delegate as! AppDelegate).apiService
    }

    var apiRootURL: URL {
        return URL(string: "https://httpbin.org")!
    }

    var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    var smallRemoteFileUrl: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
    }

    var bigRemoteFileUrl: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg")!
    }

    var fileToDownload: URL {
        if largeImageSwitch.isOn {
            return bigRemoteFileUrl
        } else {
            return smallRemoteFileUrl
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
                var image: UIImage?
                if let imageUrl = response.resourceUrl {
                    image = UIImage(contentsOfFile: imageUrl.path)
                }
                DispatchQueue.main.async {
                    strongSelf.imageView.image = image
                    strongSelf.textView.text = readable
                    strongSelf.textView.setContentOffset(.zero, animated: false)
                }
            }
        }
    }
}
