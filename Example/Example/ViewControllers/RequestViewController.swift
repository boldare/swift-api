//
//  RequestViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {

    ///Switch to decide if *resetService* or *apiService* should be used.
    @IBOutlet var restServiceSwitch: UISwitch!

    ///TextView to show output.
    @IBOutlet var textView: UITextView!

    ///Indicator to show that request is performing.
    @IBOutlet var indicator: UIActivityIndicatorView!

    //MARK: ViewController life cycle
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

    //MARK: Actions
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

//MARK: Private helpers
fileprivate extension RequestViewController {

    ///Gets *ApiManager* instance from *AppDelegate*.
    var apiManager: ApiManager {
        return (UIApplication.shared.delegate as! AppDelegate).apiManager
    }

    ///Gets *RestManager* instance from *AppDelegate*.
    var restManager: RestManager {
        return (UIApplication.shared.delegate as! AppDelegate).restManager
    }

    ///Shows response of request.
    func display(_ response: String?) {
        DispatchQueue.main.async {
            self.textView.setContentOffset(.zero, animated: false)
            self.textView.text = response
            self.indicator.stopAnimating()
        }
    }

    ///Completion handler for *apiManager*.
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

    ///Completion handler for *restManager*.
    var restCompletionHandler: RestManagerCompletionHandler {
        return {[weak self] (data: ResponseData?, readableError: String?) in
            guard let strongSelf = self else {
                return
            }
            if let errorString = readableError {
                strongSelf.display(errorString)
            } else {
                strongSelf.display(data?.readableDescription)
            }
        }
    }
}
