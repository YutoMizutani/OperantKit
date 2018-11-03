//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed interval schedule
    public func FI(_ value: Int, with entity: E) -> Observable<ReinforcementResult> {
        return self
            .fixedInterval(value, entity)
    }

    /// FI logic
    func fixedInterval(_ value: Int, _ entity: E) -> Observable<ReinforcementResult> {
        return self.map { ($0.milliseconds >= value + entity.milliseconds, $0) }
    }
}
