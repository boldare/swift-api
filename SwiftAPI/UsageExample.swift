//
//  UsageExample.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

class UsageExample {

    let service = RequestService()

    func get() {
        if let url = URL(string: "https://www.google.pl") {

            let successAction = ResponseAction.success({ (data: Data, response: HttpResponse?) in
                print("Success: \(data)")
            })
            let failureAction = ResponseAction.failure({ (error: Error) in
                print("Failure: \(error.localizedDescription)")
            })
            let request = HttpDataRequest(url: url, method: .get, onSuccess: successAction, onFailure: failureAction)

            service.sendHTTPRequest(request)
        }
    }
}
