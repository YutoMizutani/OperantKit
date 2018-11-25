//
//  VI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /**
        Variable interval schedule

        - important:
            In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
     */
    public func VI(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return variableInterval(value)
    }

    /**
        VI logic

        - important:
            In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
     */
    func variableInterval(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedInterval(value)
    }

    /// Variable interval schedule
    public func VI(_ value: Milliseconds, with entities: E...) -> Observable<ResultEntity> {
        return self
            .variableInterval(value, entities)
    }

    /// VI logic
    func variableInterval(_ value: Milliseconds, _ entities: [E]) -> Observable<ResultEntity> {
        return self.fixedInterval(value, entities)
    }
}
