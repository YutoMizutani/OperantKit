//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Single where E == ResponseEntity {

    /// Extinction schedule
    public func EXT() -> Single<Bool> {
        return extinction()
    }

    /// EXT logic
    func extinction() -> Single<Bool> {
        return self
            .asObservable()
            .map { _ in false }
            .asSingle()
    }
}
