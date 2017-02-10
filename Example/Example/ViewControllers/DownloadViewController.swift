//
//  DownloadViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {

    @IBOutlet var apiServiceSwitch: UISwitch!
    @IBOutlet var largeImageSwitch: UISwitch!
    @IBOutlet var backgroundSwitch: UISwitch!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!

    fileprivate var apiManager = ApiManager()
    fileprivate var restManager = RestManager()
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
        apiManager.cancelAllRequests()
    }

    @IBAction func requestButtonDidPush() {
        prepareForRequest()

        if apiServiceSwitch.isOn {
            startProgress(with: apiManager.downloadFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
        } else {

        }
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

    func prepareForRequest() {
        imageView.image = nil
        textView.text = ""
    }

    func startProgress(with subProgress: Progress?) {
        if let p = subProgress {
            progress.totalUnitCount += 1
            progress.addChild(p, withPendingUnitCount: 1)
        }
        progressBar.progress = Float(progress.fractionCompleted)
    }

    func resetProgress() {
        progress.removeObserver(self, forKeyPath: "fractionCompleted")
        progress = Progress(totalUnitCount: 0)
        progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
    }

    var apiCompletionHandler: ApiManagerCompletionHandler {
        return {[weak self] (readableResponse: String?, resourceUrl: URL?, error: Error?) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.progress.completedUnitCount == strongSelf.progress.totalUnitCount {
                strongSelf.resetProgress()
            }
            if let error = error {
                DispatchQueue.main.async {
                    strongSelf.textView.text = "Error ocured during request:\n\(error.localizedDescription)"
                }
            } else {
                var image: UIImage?
                if let imageUrl = resourceUrl {
                    image = UIImage(contentsOfFile: imageUrl.path)
                }
                DispatchQueue.main.async {
                    strongSelf.textView.setContentOffset(.zero, animated: false)
                    strongSelf.textView.text = readableResponse
                    strongSelf.imageView.image = image
                }
            }
        }
    }
}
