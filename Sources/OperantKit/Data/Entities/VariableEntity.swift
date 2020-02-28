//
//  VariableEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import Foundation

public class VariableEntity: ScheduleParameter {
    ///
    public var displayValue: Int
    public var nextValue: Int {
        return values[order]
    }

    /// Variable array contents
    public var values: [Int]
    /// Current order
    public var order: Int

    public init(value: Int, values: [Int], order: Int = 0) {
        self.displayValue = value
        self.values = values
        self.order = order
    }
}
