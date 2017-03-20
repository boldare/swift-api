//
//  DownloadViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {

    ///Switch to decide if *resetService* or *apiService* should be used.
    @IBOutlet var restServiceSwitch: UISwitch!

    ///Switch to decide if large or small image should be used.
    @IBOutlet var largeImageSwitch: UISwitch!

    ///Switch to decide if request should run in background or foreground.
    @IBOutlet var backgroundSwitch: UISwitch!

    ///Progress bar to show progress of request.
    @IBOutlet var progressBar: UIProgressView!

    ///ImageView to show downloaded image.
    @IBOutlet var imageView: UIImageView!

    ///TextView to show output.
    @IBOutlet var textView: UITextView!

    ///Parent of all current progresses.
    fileprivate var progress = Progress(totalUnitCount: 0)

    //MARK: ViewController life cycle
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
        restManager.cancelAllRequests()
    }

    //MARK: Actions
    @IBAction func requestButtonDidPush() {
        prepareForRequest()

        if restServiceSwitch.isOn {
            startProgress(with: restManager.getFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: restCompletionHandler))
        } else {
            startProgress(with: apiManager.downloadFile(large: largeImageSwitch.isOn, inBackground: backgroundSwitch.isOn, completion: apiCompletionHandler))
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
fileprivate extension DownloadViewController {

    ///Gets *ApiManager* instance from *AppDelegate*.
    var apiManager: ApiManager {
        return (UIApplication.shared.delegate as! AppDelegate).apiManager
    }

    ///Gets *RestManager* instance from *AppDelegate*.
    var restManager: RestManager {
        return (UIApplication.shared.delegate as! AppDelegate).fileDownloadRestManager
    }

    ///Prepares UI to request.
    func prepareForRequest() {
        imageView.image = nil
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
    func display(_ response: String?, and image: UIImage? = nil) {
        DispatchQueue.main.async {
            self.textView.setContentOffset(.zero, animated: false)
            self.textView.text = response
            self.imageView.image = image
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
                var image: UIImage?
                if let imageUrl = resourceUrl {
                    image = UIImage(contentsOfFile: imageUrl.path)
                }
                strongSelf.display(readableResponse, and: image)
            }
        }
    }

    ///Completion handler for *restManager*.
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
                var image: UIImage?
                if let imageUrl = resource?.location {
                    image = UIImage(contentsOfFile: imageUrl.path)
                }
                strongSelf.display(resource?.readableDescription, and: image)
            }
        }
    }
}
