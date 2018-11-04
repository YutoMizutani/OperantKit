//
//  FixedEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import Foundation

public class FixedEntity: ScheduleParameter {
    public var displayValue: Int
    public var nextValue: Int {
        return displayValue
    }

    public init(value: Int) {
        self.displayValue = value
    }
}
