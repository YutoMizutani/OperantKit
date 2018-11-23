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

    /// Variable ratio schedule
    public func VR(_ value: Int, with entities: E...) -> Observable<ResultEntity> {
        return self
            .variableRatio(value, entities)
    }

    /// VR logic
    func variableRatio(_ value: Int, _ entities: [E]) -> Observable<ResultEntity> {
        return fixedRatio(value, entities)
    }
}
