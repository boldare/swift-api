//
//  RestService+BackgroundEvents.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 22.02.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

//Handling background sessions - not available on macOS
public extension RestService {
    
    /**
     Handle events for background session with identifier.
     - Parameters:
     - identifier: The identifier of the URL session requiring attention.
     - completion: The completion handler to call when you finish processing the events.
     This method have to be used in `application(UIApplication, handleEventsForBackgroundURLSession: String, completionHandler: () -> Void)` method of AppDelegate.
     */
    func handleEventsForBackgroundSession(with identifier: String, completion: @escaping () -> Void) {
        apiService.handleEventsForBackgroundSession(with: identifier, completion: completion)
    }
}
