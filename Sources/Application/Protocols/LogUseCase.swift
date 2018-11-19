//
//  LogUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

public protocol LogUseCase {
    /// Stored data store
    var dataStore: LogDataStore { get set }
}

public extension LogUseCase {
    /// Store elements
    mutating func store(_ newElements: Responsible...) {
        store(newElements)
    }

    /// Store elements
    mutating func store(_ newElements: [Responsible]) {
        dataStore.append(newElements)
    }
}
