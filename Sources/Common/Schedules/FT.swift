//
//  FT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Single where E == ResponseEntity {

    /// Fixed time schedule
    public func FT(_ value: Single<Milliseconds>) -> Single<Bool> {
        return fixedTime(value)
    }

    /// FT logic
    func fixedTime(_ value: Single<Milliseconds>) -> Single<Bool> {
        return asObservable()
            .flatMap { a in value.map { a.milliseconds >= $0 } }
            .asSingle()
    }
}
