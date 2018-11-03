//
//  VariableResponseDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import Foundation

public struct VariableResponseDataStore {
    /// Stored VariableEntity current array
    public var variableEntity: VariableEntity
    /// Stored ResponseEntity when previous reinforcement
    public var lastReinforcementEntity: ResponseEntity

    public init(value: Int, iterations: Int = 12) {
        let values = FleshlerHoffman().generatedRatio(value: value, iterations: iterations)
        self.variableEntity = VariableEntity(value: value, values: values)
        self.lastReinforcementEntity = ResponseEntity()
    }

    public init(value: Int, values: [Int]) {
        self.variableEntity = VariableEntity(value: value, values: values)
        self.lastReinforcementEntity = ResponseEntity()
    }

    public init(value: Int, iterations: Int = 12, timeUnit: TimeUnit) {
        let values = FleshlerHoffman().generatedInterval(value: timeUnit.milliseconds(value), iterations: iterations)
        self.variableEntity = VariableEntity(value: value, values: values)
        self.lastReinforcementEntity = ResponseEntity()
    }

    public init(variableEntity: VariableEntity, lastReinforcementEntity: ResponseEntity = ResponseEntity()) {
        self.variableEntity = variableEntity
        self.lastReinforcementEntity = lastReinforcementEntity
    }
}
