//
//  ScheduleRecordEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/12/01.
//

import Foundation

public struct ScheduleRecordEntity {
    public var max: ResponseEntity
    /// Stored ResponseEntity when previous reinforcement
    public var lastReinforcement: ResponseEntity
    /// Extend entity
    public var extendEntity: ResponseEntity

    public static let zero: ScheduleRecordEntity
        = ScheduleRecordEntity(max: ResponseEntity.zero,
                               lastReinforcement: ResponseEntity.zero,
                               extendEntity: ResponseEntity.zero)

    public init(max: ResponseEntity,
                lastReinforcement: ResponseEntity,
                extendEntity: ResponseEntity) {
        self.max = max
        self.lastReinforcement = lastReinforcement
        self.extendEntity = extendEntity
    }
}
