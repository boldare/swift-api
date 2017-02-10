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
            apiManager.getRequest(apiCompletionHandler)
        } else {
            restManager.getResource(restCompletionHandler)
        }
    }

    @IBAction func postRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.postRequest(apiCompletionHandler)
        } else {
            restManager.postResource(restCompletionHandler)
        }
    }

    @IBAction func putRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.putRequest(apiCompletionHandler)
        } else {
            restManager.putResource(restCompletionHandler)
        }
    }

    @IBAction func patchRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.patchRequest(apiCompletionHandler)
        } else {
            restManager.patchResource(restCompletionHandler)
        }
    }

    @IBAction func deleteRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if apiServiceSwitch.isOn {
            apiManager.deleteRequest(apiCompletionHandler)
        } else {
            restManager.deleteResource(restCompletionHandler)
        }
    }
}

fileprivate extension RequestViewController {

    var apiManager: ApiManager {
        return (UIApplication.shared.delegate as! AppDelegate).apiManager
    }

    var restManager: RestManager {
        return (UIApplication.shared.delegate as! AppDelegate).restManager
    }

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

    var restCompletionHandler: RestManagerSimpleCompletionHandler {
        return {[weak self] (resource: SimpleResource?, readableError: String?) in
            guard let strongSelf = self else {
                return
            }
            if let errorString = readableError {
                DispatchQueue.main.async {
                    strongSelf.textView.text = errorString
                    strongSelf.indicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.textView.setContentOffset(.zero, animated: false)
                    strongSelf.textView.text = resource?.readableDescription
                    strongSelf.indicator.stopAnimating()
                }
            }
        }
    }
}
