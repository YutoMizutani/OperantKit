//
//  VariableIntervalScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

public struct VariableIntervalScheduleUseCase {
    public var dataStore: VariableResponseDataStore

    public init(value: Int, unit: TimeUnit, iterations: Int = 12) {
        self.dataStore = VariableResponseDataStore(value: value, unit: unit, iterations: iterations)
    }

    public init(value: Int, values: [Int]) {
        self.dataStore = VariableResponseDataStore(value: value, values: values)
    }

    public init(dataStore: VariableResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension VariableIntervalScheduleUseCase: ScheduleUseCase {
    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.VI(dataStore.variableEntity.nextValue, with: dataStore.lastReinforcementEntity)
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
