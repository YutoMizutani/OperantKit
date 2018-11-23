//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed interval schedule
    public func FI(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedInterval(value)
    }

    /// FI logic
    func fixedInterval(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return flatMap { a in value.map { a.milliseconds >= $0 } }
    }

    /// Fixed interval schedule
    public func FI(_ value: Milliseconds, with entities: E...) -> Observable<ResultEntity> {
        return self
            .fixedInterval(value, entities)
    }

    /// FI logic
    func fixedInterval(_ value: Milliseconds, _ entities: [E]) -> Observable<ResultEntity> {
        return self.map {
            ResultEntity($0.milliseconds >= value + entities.map { $0.milliseconds }.reduce(0) { $0 + $1 }, $0)
        }
    }
}
