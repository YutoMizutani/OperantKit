//
//  FT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed time schedule
    public func FT(_ value: Int, with entities: E...) -> Observable<ReinforcementResult> {
        return self
            .fixedTime(value, entities)
    }

    /// FT logic
    func fixedTime(_ value: Int, _ entities: [E]) -> Observable<ReinforcementResult> {
        return self.fixedInterval(value, entities)
    }
}
