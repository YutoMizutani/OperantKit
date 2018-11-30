//
//  ScheduleRecorder.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/23.
//

import Foundation

public class ScheduleRecorder: ScheduleRecordable {
    public var lastReinforcementEntity: ResponseEntity = ResponseEntity.zero
    public var extendEntity: ResponseEntity = ResponseEntity.zero
    public var currentOrder: Int = 0
    public var currentValue: Int = 0

    public init() {}

    public init(
        lastReinforcementEntity: ResponseEntity = ResponseEntity.zero,
        extendEntity: ResponseEntity = ResponseEntity.zero,
        currentOrder: Int = 0,
        currentValue: Int = 0
    ) {
        self.lastReinforcementEntity = lastReinforcementEntity
        self.extendEntity = extendEntity
        self.currentOrder = currentOrder
        self.currentValue = currentValue
    }
}
