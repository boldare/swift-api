//
//  Resource.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

struct Resource<A> {
    let url: URL
    let method: HttpMethod<Data>
    let parse: (Data) -> A?

    init(url: URL, method: HttpMethod<AnyObject> = .get, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.method = method.map { json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
}
