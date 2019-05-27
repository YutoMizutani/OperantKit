//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension ResponseEntity {

    /// Extinction schedule
    ///
    /// - Complexity: O(1)
    /// - Tag: .extinction()
    func extinction() -> Bool {
        return false
    }
}

public extension Single where Element == ResponseEntity {

    /// Extinction schedule
    ///
    /// - Complexity: O(1)
    /// - Tag: .EXT()
    func EXT() -> Single<Bool> {
        return map { $0.extinction() }
    }
}
