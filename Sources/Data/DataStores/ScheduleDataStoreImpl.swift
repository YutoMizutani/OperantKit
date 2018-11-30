//
//  ScheduleDataStoreImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public class ScheduleDataStoreImpl: ScheduleParameterable, ScheduleRecordable {
    public var value: Int
    public var values: [Int]
    public var currentOrder: Int = 0
    public var currentValue: Int = 0
    public var lastReinforcementEntity: ResponseEntity = ResponseEntity.zero
    public var extendEntity: ResponseEntity = ResponseEntity.zero

    public init(value: Int, values: [Int] = []) {
        self.value = value
        self.values = values
        self.currentValue = !values.isEmpty ? values[currentOrder] : value
    }

    public init(value: Int, values: [Int] = [], initValue: Int) {
        self.value = value
        self.values = values
        self.currentValue = initValue
    }
}
