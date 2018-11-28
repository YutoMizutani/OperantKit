//
//  VR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Single where E == ResponseEntity {

    /// Variable ratio schedule
    public func VR(_ value: Single<Int>) -> Single<Bool> {
        return variableRatio(value)
    }

    /// VR logic
    func variableRatio(_ value: Single<Int>) -> Single<Bool> {
        return FR(value)
    }
}
