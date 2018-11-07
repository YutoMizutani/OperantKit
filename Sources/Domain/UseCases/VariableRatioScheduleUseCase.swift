//
//  VariableRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct VariableRatioScheduleUseCase {
    public var dataStore: VariableResponseDataStore

    public init(value: Int, iterations: Int) {
        self.dataStore = VariableResponseDataStore(value: value, iterations: iterations)
    }

    public init(value: Int, values: [Int]) {
        self.dataStore = VariableResponseDataStore(value: value, values: values)
    }

    public init(dataStore: VariableResponseDataStore) {
        self.dataStore = dataStore
    }
}

extension VariableRatioScheduleUseCase: ScheduleUseCase {
    public var extendEntity: ResponseEntity {
        return dataStore.extendEntity
    }

    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.VR(dataStore.variableEntity.values[dataStore.variableEntity.order],
                           with: dataStore.lastReinforcementEntity, dataStore.extendEntity)
            .nextOrder(dataStore.variableEntity, condition: { $0.isReinforcement })
            .clearResponse(dataStore.extendEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
