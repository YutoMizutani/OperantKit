//
//  IntervalSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Interval schedule
public protocol IntervalSchedule {
    func decision(_ elapsedTime: Int, value: Int) -> Bool
}

// MARK: - Interval schedules

extension FixedIntervalSchedule: IntervalSchedule {}
extension VariableIntervalSchedule: IntervalSchedule {}
