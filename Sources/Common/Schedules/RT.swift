//
//  RT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Single where E == ResponseEntity {

    /// Random time schedule
    public func RT(_ value: Single<Milliseconds>) -> Single<Bool> {
        return randomTime(value)
    }

    /// RT logic
    func randomTime(_ value: Single<Milliseconds>) -> Single<Bool> {
        return fixedTime(value)
    }
}
