//
//  RandomRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

public struct RandomRatioScheduleUseCase {
    public var dataStore: RandomResponseDataStore

    public init(value: Int) {
        self.dataStore = RandomResponseDataStore(value: value)
    }

    public init(dataStore: RandomResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension RandomRatioScheduleUseCase: ScheduleUseCase {
    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.RR(dataStore.randomEntity.nextValue, with: dataStore.lastReinforcementEntity)
            .nextRandom(dataStore.randomEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
