//
//  Resource.swift
//  SwiftAPI
//
//  Created by Marek Kojder on 16.12.2016.
//  Copyright © 2016 XSolve. All rights reserved.
//

import Foundation

struct Resource<A> {
    let url: NSURL
    let method: HttpMethod<NSData>
    let parse: (NSData) -> A?
}
