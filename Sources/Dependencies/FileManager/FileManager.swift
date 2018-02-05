//
//  FileManager.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public protocol FileManager {

    /**
     Copies the file at the specified URL to a new location synchronously.

     - Parameters:
       - source: The file URL that identifies the file you want to copy. The URL in this parameter must not be a file reference URL. This parameter must not be nil.
       - destination: The URL at which to place the copy of srcURL. The URL in this parameter must not be a file reference URL and must include the name of the file in its new location. This parameter must not be nil.

     - Returns: Error object if operation fails, otherwise nil.

     - Important: If file exists at *destination* URL, it will replaced by file at *source* URL.
     */
    func copyFile(from source: URL, to destination: URL ) -> Error?
}
