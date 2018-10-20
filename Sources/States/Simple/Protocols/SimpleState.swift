//
//  SimpleState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Simple state
public protocol SimpleState {}

// MARK: - Simple states

extension FixedRatioState: SimpleState {}
extension FixedIntervalState: SimpleState {}
extension FixedTimeState: SimpleState {}
extension VariableRatioState: SimpleState {}
extension VariableIntervalState: SimpleState {}
extension VariableTimeState: SimpleState {}
extension RandomRatioState: SimpleState {}
extension RandomIntervalState: SimpleState {}
extension RandomTimeState: SimpleState {}
