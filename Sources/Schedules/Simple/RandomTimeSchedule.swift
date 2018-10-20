//
//  RandomTimeSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Random time (RT) schedule
public struct RandomTimeSchedule {
    /// Decision schedule
    public func decision(_ elapsedTime: Int, value: Int) -> Bool {
        return elapsedTime >= value
    }
}
