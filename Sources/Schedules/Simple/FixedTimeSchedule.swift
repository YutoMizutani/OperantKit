//
//  FixedTimeSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Fixed time (FT) schedule
public struct FixedTimeSchedule {
    public init() {}

    /// Decision schedule
    public func decision(_ elapsedTime: Int, value: Int) -> Bool {
        return elapsedTime >= value
    }
}
