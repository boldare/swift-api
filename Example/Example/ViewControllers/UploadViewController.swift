//
//  RootViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {

    ///Switch to decide if *resetService* or *apiService* should be used.
    @IBOutlet var restServiceSwitch: UISwitch!

    ///Switch to decide if large or small image should be used.
    @IBOutlet var largeImageSwitch: UISwitch!

    ///Switch to decide if request should run in background or foreground.
    @IBOutlet var backgroundSwitch: UISwitch!

    ///Progress bar to show progress of request.
    @IBOutlet var progressBar: UIProgressView!

    ///TextView to show output.
    @IBOutlet var textView: UITextView!

    ///Parent of all current progresses.
    fileprivate var progress = Progress(totalUnitCount: 0)

    //MARK: ViewController life cycle
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

    //MARK: Actions
    @IBAction func postRequestButtonDidPush() {
        prepareForRequest()

        if restServiceSwitch.isOn {
            startProgress(with: restManager.postFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: restCompletionHandler))
        } else {
            startProgress(with: apiManager.postFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
        }
    }

    @IBAction func putRequestButtonDidPush() {
        prepareForRequest()

        if restServiceSwitch.isOn {
            startProgress(with: restManager.putFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: restCompletionHandler))
        } else {
            startProgress(with: apiManager.putFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
        }
    }

    @IBAction func patchRequestButtonDidPush() {
        prepareForRequest()

        if restServiceSwitch.isOn {
            startProgress(with: restManager.patchFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: restCompletionHandler))
        } else {
            startProgress(with: apiManager.patchFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
        }
    }

    ///Observes progress changes and displays it on progress bar.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "fractionCompleted", let p = object as? Progress {
            DispatchQueue.main.async {
                self.progressBar.progress = Float(p.fractionCompleted)
            }
        }
    }
}

//MARK: Private helpers
fileprivate extension UploadViewController {

    ///Gets *ApiManager* instance from *AppDelegate*.
    var apiManager: ApiManager {
        return (UIApplication.shared.delegate as! AppDelegate).apiManager
    }

    ///Gets *RestManager* instance from *AppDelegate*.
    var restManager: RestManager {
        return (UIApplication.shared.delegate as! AppDelegate).restManager
    }

    ///Prepares UI to request.
    func prepareForRequest() {
        textView.text = ""
    }

    ///Starts new progress.
    func startProgress(with subProgress: Progress?) {
        if let p = subProgress {
            progress.totalUnitCount += 1
            progress.addChild(p, withPendingUnitCount: 1)
        }
        progressBar.progress = Float(progress.fractionCompleted)
    }

    ///Resets parent progress.
    func resetProgress() {
        progress.removeObserver(self, forKeyPath: "fractionCompleted")
        progress = Progress(totalUnitCount: 0)
        progress.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
    }

    ///Shows response of request.
    func display(_ response: String?) {
        DispatchQueue.main.async {
            self.textView.setContentOffset(.zero, animated: false)
            self.textView.text = response
        }
    }

    ///Completion handler for *apiManager*.
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

    ///Completion handler for *restManager*.
    var restCompletionHandler: RestManagerFileCompletionHandler {
        return {[weak self] (url: URL?, readableError: String?) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.progress.completedUnitCount == strongSelf.progress.totalUnitCount {
                strongSelf.resetProgress()
            }
            if let errorString = readableError {
                strongSelf.display(errorString)
            } else {
                strongSelf.display("Success!")
            }
        }
    }
}
