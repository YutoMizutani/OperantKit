//
//  VI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Variable interval schedule
    public func VI(_ value: Int, with entity: E) -> Observable<ReinforcementResult> {
        return self
            .variableInterval(value, entity)
    }

    /// VI logic
    func variableInterval(_ value: Int, _ entity: E) -> Observable<ReinforcementResult> {
        return self.fixedInterval(value, entity)
    }
}
