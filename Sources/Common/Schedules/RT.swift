//
//  RT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Random time schedule
    public func RT(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return randomTime(value)
    }

    /// RT logic
    func randomTime(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedTime(value)
    }
}
