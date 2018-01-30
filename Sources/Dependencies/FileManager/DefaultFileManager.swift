//
//  DefaultFileManager.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import Foundation

public struct DefaultFileManager: FileManager {

    public init() {}

    public func copyFile(from source: URL, to destination: URL ) -> Error? {
        let manager = Foundation.FileManager.default
        do {
            if manager.fileExists(atPath: destination.path) {
                try manager.removeItem(at: destination)
            }
            try manager.copyItem(at: source, to: destination)
        } catch {
            return error
        }
        return nil
    }
}
