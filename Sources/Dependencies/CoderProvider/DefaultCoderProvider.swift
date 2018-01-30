//
//  DefaultCoderProvider.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 30.01.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

///Default implementation of protocol
public struct DefaultCoderProvider: CoderProvider {

    public init() {}

    public var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    public var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }
}
