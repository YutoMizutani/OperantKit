//
//  FR5.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//

import RxSwift

extension Single where E == ResponseEntity {

    /// Fixed ratio schedule
    public func FR(_ value: Single<Int>) -> Single<Bool> {
        return fixedRatio(value)
    }

    /// FR logic
    func fixedRatio(_ value: Single<Int>) -> Single<Bool> {
        return asObservable()
            .flatMap { a in value.map { a.numOfResponses >= $0 } }
            .asSingle()
    }
}
