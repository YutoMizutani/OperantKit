//
//  VariableRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct VariableRatioScheduleUseCase {
    public var dataStore: VariableResponseDataStore

    public init(value: Int, iterations: Int = 12) {
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
    public func decision(_ observer: Observable<ResponseEntity>) -> Observable<ReinforcementResult> {
        return observer.VR(dataStore.variableEntity.values[dataStore.variableEntity.order], with: dataStore.lastReinforcementEntity)
            .nextOrder(dataStore.variableEntity, condition: { $0.isReinforcement })
            .storeResponse(dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
    }
}
