//
//  RequestViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {

    @IBOutlet var apiServiceSwitch: UISwitch!
    @IBOutlet var textView: UITextView!
    @IBOutlet var indicator: UIActivityIndicatorView!

    fileprivate var apiManager = ApiManager()
    fileprivate var restManager = RestManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = ""
        indicator.stopAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        apiManager.cancelAllRequests()
    }

    @IBAction func getRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.getRequest(completion: apiCompletionHandler)
        } else {

        }
    }

    @IBAction func postRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.postRequest(completion: apiCompletionHandler)
        } else {

        }
    }

    @IBAction func putRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.putRequest(completion: apiCompletionHandler)
        } else {

        }
    }

    @IBAction func patchRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.patchRequest(completion: apiCompletionHandler)
        } else {

        }
    }

    @IBAction func deleteRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.deleteRequest(completion: apiCompletionHandler)
        } else {

        }
    }
}

fileprivate extension RequestViewController {

    var apiCompletionHandler: ApiManagerCompletionHandler {
        return {[weak self] (readableResponse: String?, resourceUrl: URL?, error: Error?) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    strongSelf.textView.text = "Error ocured during request:\n\(error.localizedDescription)"
                    strongSelf.indicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.textView.setContentOffset(.zero, animated: false)
                    strongSelf.textView.text = readableResponse
                    strongSelf.indicator.stopAnimating()
                }
            }
        }
    }
}
