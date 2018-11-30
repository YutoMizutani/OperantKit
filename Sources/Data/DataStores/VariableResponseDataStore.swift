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
    /// Extend ResponseEntity
    public var extendEntity: ResponseEntity

    public init(value: Int, iterations: Int) {
        let values = FleshlerHoffman().generatedRatio(value: value, iterations: iterations)
        self.variableEntity = VariableEntity(value: value, values: values)
        self.lastReinforcementEntity = ResponseEntity.zero
        self.extendEntity = ResponseEntity.zero
    }

    public init(value: Int, values: [Int], unit: TimeUnit) {
        self.variableEntity = VariableEntity(value: value, values: values.map { unit.milliseconds($0) })
        self.lastReinforcementEntity = ResponseEntity.zero
        self.extendEntity = ResponseEntity.zero
    }

    public init(value: Int, values: [Int]) {
        self.variableEntity = VariableEntity(value: value, values: values)
        self.lastReinforcementEntity = ResponseEntity.zero
        self.extendEntity = ResponseEntity.zero
    }

    public init(value: Int, unit: TimeUnit, iterations: Int) {
        let values = FleshlerHoffman().generatedInterval(value: unit.milliseconds(value), iterations: iterations)
        self.variableEntity = VariableEntity(value: value, values: values)
        self.lastReinforcementEntity = ResponseEntity.zero
        self.extendEntity = ResponseEntity.zero
    }

    public init(variableEntity: VariableEntity,
                lastReinforcementEntity: ResponseEntity = ResponseEntity.zero,
                extendEntity: ResponseEntity = ResponseEntity.zero) {
        self.variableEntity = variableEntity
        self.lastReinforcementEntity = lastReinforcementEntity
        self.extendEntity = extendEntity
    }
}
