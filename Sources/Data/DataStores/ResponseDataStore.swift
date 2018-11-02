//
//  ResponseDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import Foundation

public struct ResponseDataStore {
    /// Stored FixedEntity
    public var fixedEntity: FixedEntity
    /// Stored ResponseEntity when previous reinforcement
    public var lastReinforcementEntity: ResponseEntity

    public init(value: Int) {
        self.fixedEntity = FixedEntity(value: value)
        self.lastReinforcementEntity = ResponseEntity()
    }

    public init(fixedEntity: FixedEntity, lastReinforcementEntity: ResponseEntity = ResponseEntity()) {
        self.fixedEntity = fixedEntity
        self.lastReinforcementEntity = lastReinforcementEntity
    }
}
