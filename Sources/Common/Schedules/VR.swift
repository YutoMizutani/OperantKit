//
//  VR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Variable ratio schedule
    public func VR(_ value: Single<Int>) -> Observable<Bool> {
        return variableRatio(value)
    }

    /// VR logic
    func variableRatio(_ value: Single<Int>) -> Observable<Bool> {
        return fixedRatio(value)
    }
}
