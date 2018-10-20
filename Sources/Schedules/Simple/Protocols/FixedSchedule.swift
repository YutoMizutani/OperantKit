//
//  FixedSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Fixed schedule
public protocol FixedSchedule {}

// MARK: - Fixed schedules

extension FixedRatioSchedule: FixedSchedule {}
extension FixedIntervalSchedule: FixedSchedule {}
extension FixedTimeSchedule: FixedSchedule {}
