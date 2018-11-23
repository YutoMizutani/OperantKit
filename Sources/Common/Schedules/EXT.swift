//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed interval schedule
    public func EXT(_ value: Single<Int>) -> Observable<Bool> {
        return extinction(value)
    }

    /// FI logic
    func extinction(_ value: Single<Int>) -> Observable<Bool> {
        return map { _ in false }
    }

    /// Extinction schedule
    public func EXT() -> Observable<ResultEntity> {
        return extinction()
    }

    /// EXT logic
    func extinction() -> Observable<ResultEntity> {
        return map { ResultEntity(false, $0) }
    }
}
