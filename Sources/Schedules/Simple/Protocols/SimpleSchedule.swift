//
//  SimpleSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Simple schedule
public protocol SimpleSchedule {
    func decision(_ responses: Int, _ time: Int, value: Int) -> Bool
}

// MARK: - Extinction schedule

extension ExtinctionSchedule: SimpleSchedule {
    public func decision(_ responses: Int, _ time: Int, value: Int) -> Bool {
        return false
    }
}

// MARK: - Fixed schedules

extension FixedRatioSchedule: SimpleSchedule {
    public func decision(_ responses: Int, _ time: Int, value: Int) -> Bool {
        return self.decision(responses, value: value)
    }
}

extension FixedIntervalSchedule: SimpleSchedule {
    public func decision(_ responses: Int, _ time: Int, value: Int) -> Bool {
        return self.decision(time, value: value)
    }
}

extension FixedTimeSchedule: SimpleSchedule {
    public func decision(_ responses: Int, _ time: Int, value: Int) -> Bool {
        return self.decision(time, value: value)
    }
}

// MARK: - Variable schedules

extension VariableRatioSchedule: SimpleSchedule {
    public func decision(_ responses: Int, _ time: Int, value: Int) -> Bool {
        return self.decision(responses, value: value)
    }
}

extension VariableIntervalSchedule: SimpleSchedule {
    public func decision(_ responses: Int, _ time: Int, value: Int) -> Bool {
        return self.decision(time, value: value)
    }
}

extension VariableTimeSchedule: SimpleSchedule {
    public func decision(_ responses: Int, _ time: Int, value: Int) -> Bool {
        return self.decision(time, value: value)
    }
}
