//
//  RR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Random ratio schedule
    public func RR(_ value: Single<Int>) -> Observable<Bool> {
        return randomRatio(value)
    }

    /// RR logic
    func randomRatio(_ value: Single<Int>) -> Observable<Bool> {
        return fixedRatio(value)
    }

    /// Random ratio schedule
    public func RR(_ value: Int, with entities: E...) -> Observable<ResultEntity> {
        return self
            .randomRatio(value, entities)
    }

    /// RR logic
    func randomRatio(_ value: Int, _ entities: [E]) -> Observable<ResultEntity> {
        return fixedRatio(value, entities)
    }
}
