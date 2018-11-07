//
//  FixedRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct FixedRatioScheduleUseCase {
    public var dataStore: FixedResponseDataStore

    public init(value: Int) {
        self.dataStore = FixedResponseDataStore(value: value)
    }

    public init(dataStore: FixedResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension FixedRatioScheduleUseCase: ScheduleUseCase {
    public var extendEntity: ResponseEntity {
        return dataStore.extendEntity
    }

    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.FR(dataStore.fixedEntity.nextValue,
                           with: dataStore.lastReinforcementEntity, dataStore.extendEntity)
            .clearResponse(dataStore.extendEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
