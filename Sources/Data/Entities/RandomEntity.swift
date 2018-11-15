//
//  RandomEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import Foundation

public class RandomEntity: ScheduleParameter {
    ///
    public var displayValue: Int
    public var nextValue: Int

    public init(value: Int) {
        self.displayValue = value
        self.nextValue = value <= 0 ? 0 : Int.random(in: 1...value)
    }
}
