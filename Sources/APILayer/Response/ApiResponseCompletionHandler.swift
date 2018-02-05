//
//  ApiResponseCompletionHandler.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 23.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public typealias ApiResponseCompletionHandler = (_ response: ApiResponse?, _ error: Error?) -> ()

extension ResponseAction {

    /**
     Creates success and failure action for single completion handler.

     - Parameter completion: ApiResponseCompletionHandler for which actions should be created.

     - Returns: Response anction for success and failure.
     */
    static func completionActions(for completion: ApiResponseCompletionHandler?) -> (success: ResponseAction?, failure: ResponseAction?) {
        guard let completion = completion else {
            //We are not creating actions if they are not needed.
            return (nil, nil)
        }
        let success = ResponseAction.success { (response) in
            if let response = ApiResponse(response) {
                completion(response, nil)
            } else {
                completion(nil, ApiError.noResponse)
            }
        }
        let failure = ResponseAction.failure { (error) in
            completion(nil, error)
        }
        return (success, failure)
    }
}
