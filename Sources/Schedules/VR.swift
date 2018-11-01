//
//  VR.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/11/01.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// function外で管理する
    public func VR(_ value: Int, with entity: ResponseEntity) -> Observable<ReinforcementResult> {
        return self
            .variableRatio(value)
    }

    /// function内で管理する
    public func VR(_ value: Int, startWith entity: ResponseEntity = ResponseEntity()) -> Observable<ReinforcementResult> {
        let values = FleshlerHoffman().generatedRatio(value: value)
        var order: Int = 0
        let lastReinforcementEntity = entity
        return self
            .fromLastResponse(lastReinforcementEntity)
            .variableRatio(values[order])
            .do(onNext: { order += $0.isReinforcement ? 1 : 0 })
            .storeRespinse(lastReinforcementEntity)
    }

    /// VR logic
    func variableRatio(_ value: Int) -> Observable<ReinforcementResult> {
        return self.map { ($0.numOfResponse >= value, $0) }
    }
}
