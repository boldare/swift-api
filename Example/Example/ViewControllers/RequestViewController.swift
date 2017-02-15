//
//  RequestViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {

    @IBOutlet var restServiceSwitch: UISwitch!
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
        restManager.cancelAllRequests()
    }

    @IBAction func getRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if restServiceSwitch.isOn {
            restManager.getResource(restCompletionHandler)
        } else {
            apiManager.getRequest(apiCompletionHandler)
        }
    }

    @IBAction func postRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if restServiceSwitch.isOn {
            restManager.postResource(restCompletionHandler)
        } else {
            apiManager.postRequest(apiCompletionHandler)
        }
    }

    @IBAction func putRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if restServiceSwitch.isOn {
            restManager.putResource(restCompletionHandler)
        } else {
            apiManager.putRequest(apiCompletionHandler)
        }
    }

    @IBAction func patchRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if restServiceSwitch.isOn {
            restManager.patchResource(restCompletionHandler)
        } else {
            apiManager.patchRequest(apiCompletionHandler)
        }
    }

    @IBAction func deleteRequestButtonDidPush() {
        textView.text = ""
        indicator.startAnimating()

        if restServiceSwitch.isOn {
            restManager.deleteResource(restCompletionHandler)
        } else {
            apiManager.deleteRequest(apiCompletionHandler)
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

    func display(_ response: String?) {
        DispatchQueue.main.async {
            self.textView.setContentOffset(.zero, animated: false)
            self.textView.text = response
            self.indicator.stopAnimating()
        }
    }

    var apiCompletionHandler: ApiManagerCompletionHandler {
        return {[weak self] (readableResponse: String?, resourceUrl: URL?, error: Error?) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.display("Error ocured during request:\n\(error.localizedDescription)")
            } else {
                strongSelf.display(readableResponse)
            }
        }
    }

    var restCompletionHandler: RestManagerSimpleCompletionHandler {
        return {[weak self] (resource: SimpleDataResource?, readableError: String?) in
            guard let strongSelf = self else {
                return
            }
            if let errorString = readableError {
                strongSelf.display(errorString)
            } else {
                strongSelf.display(resource?.readableDescription)
            }
        }
    }
}
