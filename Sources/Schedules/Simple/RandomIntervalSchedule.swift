//
//  RandomIntervalSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Random interval (RI) schedule
public struct RandomIntervalSchedule {
    public init() {}

    /// Decision schedule
    public func decision(_ elapsedTime: Int, value: Int) -> Bool {
        return elapsedTime >= value
    }
}
