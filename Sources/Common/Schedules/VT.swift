//
//  VT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Variable time schedule
    public func VT(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return variableTime(value)
    }

    /// VT logic
    func variableTime(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedInterval(value)
    }

    /// Variable time schedule
    public func VT(_ value: Milliseconds, with entities: E...) -> Observable<ResultEntity> {
        return self
            .variableTime(value, entities)
    }

    /// VT logic
    func variableTime(_ value: Milliseconds, _ entities: [E]) -> Observable<ResultEntity> {
        return self.fixedTime(value, entities)
    }
}
