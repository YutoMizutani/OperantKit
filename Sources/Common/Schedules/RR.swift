//
//  RR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

extension Single where E == ResponseEntity {

    /// Random ratio schedule
    public func RR(_ value: Single<Int>) -> Single<Bool> {
        return randomRatio(value)
    }

    /// RR logic
    func randomRatio(_ value: Single<Int>) -> Single<Bool> {
        return FR(value)
    }
}
