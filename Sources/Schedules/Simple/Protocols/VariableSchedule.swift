//
//  VariableSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Variable schedule
public protocol VariableSchedule {}

// MARK: - Variable schedules

extension VariableRatioSchedule: VariableSchedule {}
extension VariableIntervalSchedule: VariableSchedule {}
extension VariableTimeSchedule: VariableSchedule {}
