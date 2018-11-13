//
//  FixedTimeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public struct FixedTimeScheduleUseCase {
    public var dataStore: FixedResponseDataStore

    public init(value: Int, unit: TimeUnit) {
        self.dataStore = FixedResponseDataStore(value: value, unit: unit)
    }

    public init(dataStore: FixedResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension FixedTimeScheduleUseCase: ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .fixedTime
    }

    public var extendEntity: ResponseEntity {
        return dataStore.extendEntity
    }

    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.FT(dataStore.fixedEntity.nextValue,
                           with: dataStore.lastReinforcementEntity, dataStore.extendEntity)
            .clearResponse(dataStore.extendEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
