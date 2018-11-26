//
//  VT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Variable time schedule
    public func VT(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return variableTime(value)
    }

    /// VT logic
    func variableTime(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedTime(value)
    }
}
