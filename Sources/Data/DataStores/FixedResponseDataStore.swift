//
//  FixedResponseDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import Foundation

public struct FixedResponseDataStore {
    /// Stored FixedEntity
    public var fixedEntity: FixedEntity
    /// Stored ResponseEntity when previous reinforcement
    public var lastReinforcementEntity: ResponseEntity
    /// Extend ResponseEntity
    public var extendEntity: ResponseEntity

    public init(value: Int) {
        self.fixedEntity = FixedEntity(value: value)
        self.lastReinforcementEntity = ResponseEntity.zero
        self.extendEntity = ResponseEntity.zero
    }

    public init(value: Int, unit: TimeUnit) {
        self.fixedEntity = FixedEntity(value: unit.milliseconds(value))
        self.lastReinforcementEntity = ResponseEntity.zero
        self.extendEntity = ResponseEntity.zero
    }

    public init(fixedEntity: FixedEntity,
                lastReinforcementEntity: ResponseEntity = ResponseEntity.zero,
                extendEntity: ResponseEntity = ResponseEntity.zero) {
        self.fixedEntity = fixedEntity
        self.lastReinforcementEntity = lastReinforcementEntity
        self.extendEntity = extendEntity
    }
}
