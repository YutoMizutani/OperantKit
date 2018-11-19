//
//  RI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Random interval schedule
    public func RI(_ value: Milliseconds, with entities: E...) -> Observable<ReinforcementResult> {
        return self
            .randomInterval(value, entities)
    }

    /// RI logic
    func randomInterval(_ value: Milliseconds, _ entities: [E]) -> Observable<ReinforcementResult> {
        return self.fixedInterval(value, entities)
    }
}
