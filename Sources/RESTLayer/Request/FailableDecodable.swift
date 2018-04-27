//
//  FailableDecodable.swift
//  SwiftAPI iOS
//
//  Created by Marek Kojder on 26.01.2018.
//  Copyright © 2018 XSolve. All rights reserved.
//

import Foundation

public extension KeyedDecodingContainer {

    /**
     Decodes an arry of values of the given type for the given key.

     - Parameters:
       - type: The type of values in array to decode.
       - key: The key that the decoded array is associated with.

     - Throws:
       - `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
       - `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
       - `DecodingError.valueNotFound` if `self` has a null entry for the given key.

     - Returns: An array of values of the requested type, if present for the given key and convertible to the requested type and number of failed attempts of conversion.

     This method is strongly advised for decoding arrays in which may appear incorrect values. In that case that method will not fail all array but only this particular values.
     */
    public func decodeArray<T: Decodable>(of type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> (array: [T], failedCount: Int) {
        let decoded = try decode(ApiArray<T>.self, forKey: key)
        if decoded.array.isEmpty, decoded.failedItemsCount > 0 {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: [key], debugDescription: "Parsing failed for all elements of array."))
        }
        return (decoded.array, decoded.failedItemsCount)
    }
}

private struct ApiArray<T: Decodable>: Decodable {
    let array: [T]
    let failedItemsCount: Int

    init(from decoder: Decoder) throws {
        let dataArray = try [FailableData<T>](from: decoder)
        array = dataArray.compactMap({ $0.value })
        failedItemsCount = dataArray.filter({ $0.failed == true }).count
    }
}

private struct FailableData<T: Decodable>: Decodable {
    let value: T?
    let failed: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            value = try container.decode(T.self)
            failed = false
        } catch {
            value = nil
            failed = true
        }
    }
}
