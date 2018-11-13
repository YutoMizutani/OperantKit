//
//  VariableTimeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public struct VariableTimeScheduleUseCase {
    public var dataStore: VariableResponseDataStore

    public init(value: Int, unit: TimeUnit, iterations: Int = 12) {
        self.dataStore = VariableResponseDataStore(value: value, unit: unit, iterations: iterations)
    }

    public init(value: Int, values: [Int], unit: TimeUnit) {
        self.dataStore = VariableResponseDataStore(value: value, values: values, unit: unit)
    }

    public init(value: Int, values: [Int]) {
        self.dataStore = VariableResponseDataStore(value: value, values: values)
    }

    public init(dataStore: VariableResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension VariableTimeScheduleUseCase: ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .variableTime
    }

    public var extendEntity: ResponseEntity {
        return dataStore.extendEntity
    }

    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.VT(dataStore.variableEntity.nextValue,
                           with: dataStore.lastReinforcementEntity, dataStore.extendEntity)
            .clearResponse(dataStore.extendEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
