//
//  VT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Variable time schedule
    public func VT(_ value: Int, with entities: E...) -> Observable<ReinforcementResult> {
        return self
            .variableTime(value, entities)
    }

    /// VT logic
    func variableTime(_ value: Int, _ entities: [E]) -> Observable<ReinforcementResult> {
        return self.fixedTime(value, entities)
    }
}
