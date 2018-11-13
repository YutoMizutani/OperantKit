//
//  VR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Variable ratio schedule
    public func VR(_ value: Int, with entities: E...) -> Observable<ReinforcementResult> {
        return self
            .variableRatio(value, entities)
    }

    /// VR logic
    func variableRatio(_ value: Int, _ entities: [E]) -> Observable<ReinforcementResult> {
        return fixedRatio(value, entities)
    }
}
