//
//  ResponseRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

public protocol ResponseRecordable {
    /// Stored responses
    var responses: [Responsible] { get set }
}

public extension ResponseRecordable {
    /// Append log elements
    mutating func append(_ newElements: Responsible...) {
        append(newElements)
    }

    /// Append log elements
    mutating func append(_ newElements: [Responsible]) {
        responses += newElements
    }

    /// Insert log elements at the index
    mutating func insert(_ newElements: Responsible..., at index: Int) {
        insert(newElements, at: index)
    }

    /// Insert log elements at the index
    mutating func insert(_ newElements: [Responsible], at index: Int) {
        switch index {
        case ...0:
            responses = newElements + responses
        case let i where i < responses.count:
            responses = responses.prefix(i) + newElements + responses.suffix(responses.count - i)
        default:
            append(newElements)
        }
    }
}
