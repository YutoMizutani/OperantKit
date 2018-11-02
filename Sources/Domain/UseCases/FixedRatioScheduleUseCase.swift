//
//  FixedRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct FixedRatioScheduleUseCase {
    public var value: Int
    public var dataStore: ResponseDataStore

    public init(value: Int, dataStore: ResponseDataStore) {
        self.value = value
        self.dataStore = dataStore
    }
}

extension FixedRatioScheduleUseCase: ScheduleUseCase {
    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.FR(value, with: dataStore.lastReinforcementEntity)
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
