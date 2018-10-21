//
//  Schedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/21.
//

import Foundation

public protocol Schedule {}

extension FixedRatioSchedule: Schedule {}
extension FixedIntervalSchedule: Schedule {}
extension FixedTimeSchedule: Schedule {}
extension VariableRatioSchedule: Schedule {}
extension VariableIntervalSchedule: Schedule {}
extension VariableTimeSchedule: Schedule {}
extension RandomRatioSchedule: Schedule {}
extension RandomIntervalSchedule: Schedule {}
extension RandomTimeSchedule: Schedule {}
