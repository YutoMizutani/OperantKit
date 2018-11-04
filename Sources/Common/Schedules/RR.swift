//
//  RR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Random ratio schedule
    public func RR(_ value: Int, with entity: E) -> Observable<ReinforcementResult> {
        return self
            .randomRatio(value, entity)
    }

    /// RR logic
    func randomRatio(_ value: Int, _ entity: E) -> Observable<ReinforcementResult> {
        return fixedRatio(value, entity)
    }
}
