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
    /// - Important: FR 1 と結果は同一ですが，値の取得に伴なうクロージャの分だけこちらがより高速に動作します。
    ///
    /// - Complexity: O(1)
    /// - Tag: .CRF()
    func CRF() -> Single<Bool> {
        return map { r in r.fixedRatio(1) }
    }
}
