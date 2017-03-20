//
//  RequestCallback.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 20.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

/**
 Closures to perform when request has finished.

 - success: called when server responded,
 - failure: called when request has failed.
 */
enum ResponseAction {
    case success((HttpResponse?) -> Void)
    case failure((Error) -> Void)
}

extension ResponseAction {

    /**
     Performs action with given parameter.

     - Parameter error: Error object returned by service.
     
     This method runs only failure action and ignores other ones.
     */
    func perform(with error: Error) {
        switch self {
        case .failure(let action):
            action(error)
        default:
            break
        }
    }

    /**
     Performs action with given parameter.

     - Parameters:
       - data: Data object returned by server.
       - response: Optional HttpResponse returned by service.

     This method runs only success action and ignores other ones.
     */
    func perform(with response: HttpResponse?) {
        switch self {
        case .success(let action):
            action(response)
        default:
            break
        }
    }
}

extension ResponseAction {

    /**
     Checks if given action is the same type with current one.

     - Parameter action: action to compare with.
     
     This method is comparing only types of actions but ignoring actions body.
     */
    func isEqualByType(with action: ResponseAction) -> Bool {
        switch (self, action) {
        case (.success(_), .success(_)):
            return true

        case (.failure(_), .failure(_)):
            return true

        default:
            return false
        }
    }
}
