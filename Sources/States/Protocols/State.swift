//
//  State.swift
//  OperantKit iOS
//
//  Created by Yuto Mizutani on 2018/10/21.
//

import Foundation

public protocol State {}

extension FixedRatioState: State {}
extension FixedIntervalState: State {}
extension FixedTimeState: State {}
extension VariableRatioState: State {}
extension VariableIntervalState: State {}
extension VariableTimeState: State {}
extension RandomRatioState: State {}
extension RandomIntervalState: State {}
extension RandomTimeState: State {}
