//
//  FixedRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct FixedRatioScheduleUseCase {
    public var dataStore: ResponseDataStore

    public init(value: Int) {
        self.dataStore = ResponseDataStore(value: value)
    }

    public init(dataStore: ResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension FixedRatioScheduleUseCase: ScheduleUseCase {
    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.FR(dataStore.fixedEntity.value, with: dataStore.lastReinforcementEntity)
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
