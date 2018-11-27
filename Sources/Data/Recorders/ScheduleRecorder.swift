//
//  ScheduleRecorder.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/23.
//

import Foundation

public class ScheduleRecorder: ScheduleRecordable {
    public var lastReinforcementEntity: ResponseEntity = ResponseEntity()
    public var extendEntity: ResponseEntity = ResponseEntity()
    public var currentOrder: Int = 0
    public var currentValue: Int = 0

    public init() {}

    public init(
        lastReinforcementEntity: ResponseEntity = ResponseEntity(),
        extendEntity: ResponseEntity = ResponseEntity(),
        currentOrder: Int = 0,
        currentValue: Int = 0
    ) {
        self.lastReinforcementEntity = lastReinforcementEntity
        self.extendEntity = extendEntity
        self.currentOrder = currentOrder
        self.currentValue = currentValue
    }
}
