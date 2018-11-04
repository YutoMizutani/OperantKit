//
//  FixedIntervalScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

public struct FixedIntervalScheduleUseCase {
    public var dataStore: FixedResponseDataStore

    public init(value: Int, unit: TimeUnit) {
        self.dataStore = FixedResponseDataStore(value: value, unit: unit)
    }

    public init(dataStore: FixedResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension FixedIntervalScheduleUseCase: ScheduleUseCase {
    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.FI(dataStore.fixedEntity.nextValue, with: dataStore.lastReinforcementEntity)
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
