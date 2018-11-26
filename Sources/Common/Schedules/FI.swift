//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /**
        Fixed interval schedule

        - important:
            In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
     */
    public func FI(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedInterval(value)
    }

    /**
        FI logic

        - important:
            In order to distinguish from Time schedule, there is a limitation of one or more responses since last time.
     */
    func fixedInterval(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return store(startWith: ResponseEntity())
            .flatMap { a in
                value.map {
                    a.newValue.numOfResponses - a.oldValue.numOfResponses > 0
                        && a.newValue.milliseconds >= $0
                }
            }
    }
}
