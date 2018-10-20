//
//  RandomSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Random schedule
public protocol RandomSchedule {}

// MARK: - Random schedules

extension RandomRatioSchedule: RandomSchedule {}
extension RandomIntervalSchedule: RandomSchedule {}
extension RandomTimeSchedule: RandomSchedule {}
