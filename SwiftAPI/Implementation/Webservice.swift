//
//  APIRequest.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

final class Webservice {

    private let configuration: URLSessionConfiguration

    private var session: URLSession {
        return URLSession(configuration: configuration)
    }

    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }

    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        let request = URLRequest(resource: resource)
        session.dataTask(with: request) { data, _, _ in
            completion(data.flatMap(resource.parse))
            }.resume()
    }
}

fileprivate extension URLRequest {
    init<A>(resource: Resource<A>) {
        self.init(url: resource.url)

        self.httpMethod = resource.method.method
        if case let .post(data) = resource.method {
            self.httpBody = data
        }
    }
}
