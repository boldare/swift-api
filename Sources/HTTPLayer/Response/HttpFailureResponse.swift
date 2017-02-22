//
//  HttpFailureResponse.swift
//  Pods
//
//  Created by Marek Kojder on 12.01.2017.
//
//

import Foundation

class HttpFailureResponse: HttpResponse {

    ///Error object related to failure response.
    private(set) var error: Error

    /**
     Creates object and sets its url and error.

     - Parameters:
       - url: URL for the response.
       - error: Error object related to failure response.
     */
    init(url: URL, error: Error) {
        self.error = error
        super.init(urlResponse: URLResponse(url: url, mimeType: nil, expectedContentLength: -1, textEncodingName: nil))
    }

    //MARK: - Forbidden properties and methods

    @available(*, deprecated)
    override var expectedContentLength: Int64 {
        return -1
    }

    @available(*, deprecated)
    override var mimeType: String? {
        return nil
    }

    @available(*, deprecated)
    override var textEncodingName: String? {
        return nil
    }

    @available(*, deprecated)
    override var statusCode: Int? {
        return nil
    }

    @available(*, deprecated)
    override var allHeaderFields: [String : String]? {
        return nil
    }

    @available(*, deprecated)
    override var body: Data? {
        return nil
    }

    @available(*, deprecated)
    override var resourceUrl: URL? {
        return nil
    }

    ///Method not allowed to use in current class.
    @available(*, deprecated)
    override private init(body: Data) {
        self.error = NSError()
        super.init(body: body)
    }

    ///Method not allowed to use in current class.
    @available(*, deprecated)
    override private init(resourceUrl: URL) {
        self.error = NSError()
        super.init(resourceUrl: resourceUrl)
    }

    ///Method not allowed to use in current class.
    @available(*, deprecated)
    override private init(urlResponse: URLResponse) {
        self.error = NSError()
        super.init(urlResponse: urlResponse)
    }

    ///Method not allowed to use in current class.
    @available(*, deprecated)
    override func update(with urlResponse: URLResponse) {
    }

    ///Method not allowed to use in current class.
    @available(*, deprecated)
    override func appendBody(_ data: Data) {
    }
}
