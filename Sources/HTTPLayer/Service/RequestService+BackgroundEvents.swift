//
//  sad.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 22.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

//Handling background sessions - not available on macOS
extension RequestService {

    /**
     Handle events for background session with identifier.

     - Parameters:
     - identifier: The identifier of the URL session requiring attention.
     - completionHandler: The completion handler to call when you finish processing the events.

     This method have to be used in `application(UIApplication, handleEventsForBackgroundURLSession: String, completionHandler: () -> Void)` method of AppDelegate.
     */
    func handleEventsForBackgroundSession(with identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler[identifier] = completionHandler
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        for (_, completionHandler) in backgroundSessionCompletionHandler {
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        backgroundSessionCompletionHandler.removeAll()
    }
}
