//
//  RI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Random interval schedule
    public func RI(_ value: Int, with entity: E) -> Observable<ReinforcementResult> {
        return self
            .randomInterval(value, entity)
    }

    /// RI logic
    func randomInterval(_ value: Int, _ entity: E) -> Observable<ReinforcementResult> {
        return self.fixedInterval(value, entity)
    }
}
