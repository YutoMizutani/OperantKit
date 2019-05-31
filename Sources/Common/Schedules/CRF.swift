//
//  CRF.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/28.
//

import RxSwift

public extension Single where Element == ResponseEntity {

    /// Continuous Reinforcement schedule
    ///
    /// - Important: Works faster than FR 1.
    /// - Parameter value: Reinforcement value
    /// - Complexity: O(1)
    /// - Tag: .CRF()
    func CRF() -> Single<Bool> {
        return map { r in r.fixedRatio(1) }
    }
}
