//
//  FR5.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed ratio schedule
    public func FR(_ value: Single<Int>) -> Observable<Bool> {
        return fixedRatio(value)
    }

    /// FR logic
    func fixedRatio(_ value: Single<Int>) -> Observable<Bool> {
        return flatMap { a in value.map { a.numOfResponses >= $0 } }
    }

    /// Fixed ratio schedule
    public func FR(_ value: Int, with entities: E...) -> Observable<ResultEntity> {
        return self
            .fixedRatio(value, entities)
    }

    /// FR logic
    func fixedRatio(_ value: Int, _ entities: [E]) -> Observable<ResultEntity> {
        return self.map {
            ResultEntity(($0.numOfResponses >= value + entities.map { $0.numOfResponses }.reduce(0) { $0 + $1 }), $0)
        }
    }
}
