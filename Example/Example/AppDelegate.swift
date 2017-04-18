//
//  AppDelegate.swift
//  Example
//
//  Created by Marek Kojder on 31.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    ///*ApiManager* instance.
    lazy var apiManager = ApiManager()

    ///*RestManager* instance for data requests and file uploading.
    lazy var restManager = RestManager(forFileDownload: false)

    ///*RestManager* instance only for file downloading.
    lazy var fileDownloadRestManager = RestManager(forFileDownload: true)

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        apiManager.handleEventsForBackgroundSession(with: identifier, completionHandler: completionHandler)
        restManager.handleEventsForBackgroundSession(with: identifier, completionHandler: completionHandler)
        fileDownloadRestManager.handleEventsForBackgroundSession(with: identifier, completionHandler: completionHandler)
    }
}
