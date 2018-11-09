//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed interval schedule
    public func FI(_ value: Int, with entities: E...) -> Observable<ReinforcementResult> {
        return self
            .fixedInterval(value, entities)
    }

    /// FI logic
    func fixedInterval(_ value: Int, _ entities: [E]) -> Observable<ReinforcementResult> {
        return self.map {
            ($0.milliseconds >= value + entities.map { $0.milliseconds }.reduce(0) { $0 + $1 }, $0)
        }
    }
}
