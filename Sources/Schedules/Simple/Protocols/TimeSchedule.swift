//
//  TimeSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Time schedule
public protocol TimeSchedule {
    func decision(_ elapsedTime: Int, value: Int) -> Bool
}

// MARK: - Time schedules

extension FixedTimeSchedule: TimeSchedule {}
extension VariableTimeSchedule: TimeSchedule {}
