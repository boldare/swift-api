//
//  CoderProvider.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 26.01.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import Foundation

public protocol CoderProvider {

    ///JSON decoder which should be used for decoding received data.
    var decoder: JSONDecoder { get }

    ///JSON encoder which should be used for endcoding sending data.
    var encoder: JSONEncoder { get }
}

extension CoderProvider {

    ///Decodes given `type` from given `data`.
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try decoder.decode(type, from: data)
    }

    ///Encodes given `value` to *Data* instance.
    func encode<T: Encodable>(_ value: T) throws -> Data {
        return try encoder.encode(value)
    }
}
