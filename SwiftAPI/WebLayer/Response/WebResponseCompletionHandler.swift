//
//  WebResponseCompletionHandler.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 23.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

typealias WebResponseCompletionHandler = (WebResponse?, Error?) -> ()

extension ResponseAction {

    /**
     Creates success and failure action for single completion handler.

     - Parameter completion: WebResponseCompletionHandler for which actions should be created.

     - Returns: Response anction for success and failure.
     */
    static func completionActions(for completion: WebResponseCompletionHandler?) -> (success: ResponseAction, failure: ResponseAction) {
        let success = ResponseAction.success { (response) in
            if let response = WebResponse(response) {
                completion?(response, nil)
            } else {
                completion?(nil, WebError.noResponse)
            }
        }
        let failure = ResponseAction.failure { (error) in
            completion?(nil, error)
        }
        return (success, failure)
    }
}
