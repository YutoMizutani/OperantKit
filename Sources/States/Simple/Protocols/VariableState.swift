//
//  VariableState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Variable states
public protocol VariableState {}

// MARK: - Variable states

extension VariableRatioState: VariableState {}
extension VariableIntervalState: VariableState {}
extension VariableTimeState: VariableState {}
