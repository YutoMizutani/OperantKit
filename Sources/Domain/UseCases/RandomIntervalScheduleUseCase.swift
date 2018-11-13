//
//  RandomIntervalScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

public struct RandomIntervalScheduleUseCase {
    public var dataStore: RandomResponseDataStore

    public init(value: Int, unit: TimeUnit) {
        self.dataStore = RandomResponseDataStore(value: value, unit: unit)
    }

    public init(dataStore: RandomResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension RandomIntervalScheduleUseCase: ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .randomInterval
    }

    public var extendEntity: ResponseEntity {
        return dataStore.extendEntity
    }

    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.RI(dataStore.randomEntity.nextValue,
                           with: dataStore.lastReinforcementEntity, dataStore.extendEntity)
            .clearResponse(dataStore.extendEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
