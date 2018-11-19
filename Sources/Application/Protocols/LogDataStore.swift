//
//  LogDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

public protocol LogDataStore {
    /// Stored log entity
    var log: Loggable { get set }
}

public extension LogDataStore {
    /// Append log elements
    mutating func append(_ newElements: Responsible...) {
        append(newElements)
    }

    /// Append log elements
    mutating func append(_ newElements: [Responsible]) {
        log.responses += newElements
    }

    /// Insert log elements at the index
    mutating func insert(_ newElements: Responsible..., at index: Int) {
        insert(newElements, at: index)
    }

    /// Insert log elements at the index
    mutating func insert(_ newElements: [Responsible], at index: Int) {
        switch index {
        case ...0:
            log.responses = newElements + log.responses
        case let i where i < log.responses.count:
            log.responses = log.responses.prefix(i) + newElements + log.responses.suffix(log.responses.count - i)
        default:
            append(newElements)
        }
    }
}
