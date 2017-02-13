//
//  RootViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {

    @IBOutlet var apiServiceSwitch: UISwitch!
    @IBOutlet var largeImageSwitch: UISwitch!
    @IBOutlet var backgroundSwitch: UISwitch!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var textView: UITextView!

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
        
        apiManager.cancelAllRequests()
        restManager.cancelAllRequests()
    }

    @IBAction func postRequestButtonDidPush() {
        prepareForRequest()

        if apiServiceSwitch.isOn {
            startProgress(with: apiManager.postFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
        } else {

        }
    }

    @IBAction func putRequestButtonDidPush() {
        prepareForRequest()

        if apiServiceSwitch.isOn {
            startProgress(with: apiManager.putFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
        } else {

        }
    }

    @IBAction func patchRequestButtonDidPush() {
        prepareForRequest()

        if apiServiceSwitch.isOn {
            startProgress(with: apiManager.patchFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
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

fileprivate extension UploadViewController {

    var apiManager: ApiManager {
        return (UIApplication.shared.delegate as! AppDelegate).apiManager
    }

    var restManager: RestManager {
        return (UIApplication.shared.delegate as! AppDelegate).restManager
    }

    func prepareForRequest() {
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

    func display(_ response: String?) {
        DispatchQueue.main.async {
            self.textView.setContentOffset(.zero, animated: false)
            self.textView.text = response
        }
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
                strongSelf.display("Error ocured during request:\n\(error.localizedDescription)")
            } else {
                strongSelf.display(readableResponse)
            }
        }
    }

    var restCompletionHandler: RestManagerFileCompletionHandler {
        return {[weak self] (resource: SimpleFileResource?, readableError: String?) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.progress.completedUnitCount == strongSelf.progress.totalUnitCount {
                strongSelf.resetProgress()
            }
            if let errorString = readableError {
                strongSelf.display(errorString)
            } else {
                strongSelf.display(resource?.readableDescription)
            }
        }
    }
}
