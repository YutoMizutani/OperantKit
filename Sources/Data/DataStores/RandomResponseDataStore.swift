//
//  RandomResponseDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import Foundation

public struct RandomResponseDataStore {
    /// Stored RandomEntity
    public var randomEntity: RandomEntity
    /// Stored ResponseEntity when previous reinforcement
    public var lastReinforcementEntity: ResponseEntity
    /// Extend entity
    public var extendEntity: ResponseEntity

    public init(value: Int) {
        self.randomEntity = RandomEntity(value: value)
        self.lastReinforcementEntity = ResponseEntity()
        self.extendEntity = ResponseEntity()
    }

    public init(value: Int, unit: TimeUnit) {
        self.randomEntity = RandomEntity(value: unit.milliseconds(value))
        self.lastReinforcementEntity = ResponseEntity()
        self.extendEntity = ResponseEntity()
    }

    public init(randomEntity: RandomEntity,
                lastReinforcementEntity: ResponseEntity = ResponseEntity(),
                extendEntity: ResponseEntity = ResponseEntity()) {
        self.randomEntity = randomEntity
        self.lastReinforcementEntity = lastReinforcementEntity
        self.extendEntity = extendEntity
    }
}
