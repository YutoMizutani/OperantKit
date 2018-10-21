//
//  RatioSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Ratio schedule
public protocol RatioSchedule {
    func decision(_ response: Int, value: Int) -> Bool
}

// MARK: - Ratio schedules

extension FixedRatioSchedule: RatioSchedule {}
extension VariableRatioSchedule: RatioSchedule {}
extension RandomRatioSchedule: RatioSchedule {}
