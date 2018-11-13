//
//  RandomTimeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public struct RandomTimeScheduleUseCase {
    public var dataStore: RandomResponseDataStore

    public init(value: Int, unit: TimeUnit) {
        self.dataStore = RandomResponseDataStore(value: value, unit: unit)
    }

    public init(dataStore: RandomResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension RandomTimeScheduleUseCase: ScheduleUseCase {
    public var extendEntity: ResponseEntity {
        return dataStore.extendEntity
    }

    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.RT(dataStore.randomEntity.nextValue,
                           with: dataStore.lastReinforcementEntity, dataStore.extendEntity)
            .clearResponse(dataStore.extendEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
