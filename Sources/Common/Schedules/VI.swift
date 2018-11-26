//
//  VI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

extension Single where E == ResponseEntity {

    /**
        Variable interval schedule

        - important:
            In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
     */
    public func VI(_ value: Single<Milliseconds>) -> Single<Bool> {
        return variableInterval(value)
    }

    /**
        VI logic

        - important:
            In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
     */
    func variableInterval(_ value: Single<Milliseconds>) -> Single<Bool> {
        return fixedInterval(value)
    }
}
