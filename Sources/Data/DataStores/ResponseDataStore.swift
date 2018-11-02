//
//  ResponseDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import Foundation

public struct ResponseDataStore {
    /// Stored ResponseEntity when previous reinforcement
    public var lastReinforcementEntity: ResponseEntity

    init(lastReinforcementEntity: ResponseEntity = ResponseEntity()) {
        self.lastReinforcementEntity = lastReinforcementEntity
    }
}
