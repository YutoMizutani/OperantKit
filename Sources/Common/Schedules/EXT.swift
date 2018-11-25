//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Extinction schedule
    public func EXT() -> Observable<Bool> {
        return extinction()
    }

    /// EXT logic
    func extinction() -> Observable<Bool> {
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
