//
//  UsageExample.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

class UsageExample {

    let webservice = Webservice()

    func get() {
        if let url = URL(string: "https://www.google.pl") {
            let request = HttpRequest(baseUrl: url, httpMethod: .get)
            let success = ResponseAction.success({ (data: Data, response: HttpResponse?) in
                print("Success: \(data)")
            })
            let failure = ResponseAction.failure({ (error: Error) in
                print("Failure: \(error.localizedDescription)")
            })
            webservice.sendHTTPRequest(request, actions: [success, failure])
        }
    }
}
