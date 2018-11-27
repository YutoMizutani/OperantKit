//
//  ScheduleRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol ScheduleRecordable: class {
    /// Stored ResponseEntity when previous reinforcement
    var lastReinforcementEntity: ResponseEntity { get set }
    /// Extend entity
    var extendEntity: ResponseEntity { get set }
    var currentOrder: Int { get set }
    var currentValue: Int { get set }
}
