//
//  RI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Random interval schedule
    public func RI(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return randomInterval(value)
    }

    /// RI logic
    func randomInterval(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedInterval(value)
    }

    /// Random interval schedule
    public func RI(_ value: Milliseconds, with entities: E...) -> Observable<ResultEntity> {
        return self
            .randomInterval(value, entities)
    }

    /// RI logic
    func randomInterval(_ value: Milliseconds, _ entities: [E]) -> Observable<ResultEntity> {
        return self.fixedInterval(value, entities)
    }
}
