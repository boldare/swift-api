//
//  DownloadViewController.swift
//  PodDebug
//
//  Created by Marek Kojder on 30.01.2017.
//  Copyright © 2017 XSolve. All rights reserved.
//

import UIKit
import SwiftAPI

class DownloadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DownloadViewController {

    fileprivate var apiService: ApiService {
        return (UIApplication.shared.delegate as! AppDelegate).apiService
    }

    fileprivate var documentsUrl: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    }

    fileprivate var smallRemoteFileUrl: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d1/Mount_Everest_as_seen_from_Drukair2_PLW_edit.jpg")!
    }

    fileprivate var bigRemoteFileUrl: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg")!
    }

    fileprivate var smallLocalFileURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "smallImage", withExtension: "png")!
    }

    fileprivate var bigLocalFileURL: URL {
        return Bundle(for: type(of: self)).url(forResource: "bigImage", withExtension: "jpg")!
    }
}
