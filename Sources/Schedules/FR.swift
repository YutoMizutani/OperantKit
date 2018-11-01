//
//  FR5.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/31.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public func fixedRatio(value: Int) -> ((Observable<ResponseEntity>) -> Observable<ReinforcementResult>) {
    return { $0.FR(value) }
}

extension Observable where E == ResponseEntity {

    /// function外で管理する
    public func FR(_ value: Int, with entity: ResponseEntity) -> Observable<ReinforcementResult> {
        return self
            .fixedRatio(value)
    }

    /// function内で管理する
    public func FR(_ value: Int, startWith entity: ResponseEntity = ResponseEntity()) -> Observable<ReinforcementResult> {
        let lastReinforcementEntity = entity
        return self
            .fromLastResponse(lastReinforcementEntity)
            .fixedRatio(value)
            .storeRespinse(lastReinforcementEntity)
    }

    /// FR logic
    func fixedRatio(_ value: Int) -> Observable<ReinforcementResult> {
        return self.map { ($0.numOfResponse >= value, $0) }
    }
}
