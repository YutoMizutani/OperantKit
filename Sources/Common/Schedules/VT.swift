//
//  VT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Single where E == ResponseEntity {

    /// Variable time schedule
    public func VT(_ value: Single<Milliseconds>) -> Single<Bool> {
        return variableTime(value)
    }

    /// VT logic
    func variableTime(_ value: Single<Milliseconds>) -> Single<Bool> {
        return fixedTime(value)
    }
}
