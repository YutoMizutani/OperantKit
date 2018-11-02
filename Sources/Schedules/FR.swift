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
    public func FR(_ value: Int, with entity: E) -> Observable<ReinforcementResult> {
        return self
            .fixedRatio(value, entity)
    }

    /// function内で管理する
    public func FR(_ value: Int, startWith numOfResponse: Int = 0) -> Observable<ReinforcementResult> {
        let lastReinforcementEntity: E = ResponseEntity(numOfResponse: numOfResponse)

        return self
            .fixedRatio(value, lastReinforcementEntity)
            .storeResponse(lastReinforcementEntity, condition: { $0.isReinforcement })
    }

    /// FR logic
    func fixedRatio(_ value: Int, _ entity: E) -> Observable<ReinforcementResult> {
        return self.map { (($0.numOfResponse >= value + entity.numOfResponse), $0) }
    }
}
