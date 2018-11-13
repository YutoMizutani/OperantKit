//
//  FR5.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed ratio schedule
    public func FR(_ value: Int, with entities: E...) -> Observable<ReinforcementResult> {
        return self
            .fixedRatio(value, entities)
    }

    /// FR logic
    func fixedRatio(_ value: Int, _ entities: [E]) -> Observable<ReinforcementResult> {
        return self.map {
            (($0.numOfResponse >= value + entities.map { $0.numOfResponse }.reduce(0) { $0 + $1 }), $0)
        }
    }
}
