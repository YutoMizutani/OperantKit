//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension ResponseEntity {

    /// Extinction schedule
    /// - Complexity: O(1)
    func extinction() -> Bool {
        return false
    }
}

public extension Single where E == ResponseEntity {

    /// Extinction schedule
    /// - Complexity: O(1)
    func EXT() -> Single<Bool> {
        return map { $0.extinction() }
    }
}
