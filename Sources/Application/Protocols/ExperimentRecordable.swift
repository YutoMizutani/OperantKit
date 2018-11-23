//
//  ExperimentRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

public protocol ExperimentRecordable: class {
    /// Stored ResponseEntity when previous reinforcement
    var lastReinforcementEntity: ResponseEntity { get set }
    /// Extend entity
    var extendEntity: ResponseEntity { get set }
}
