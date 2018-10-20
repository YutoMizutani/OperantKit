//
//  Parameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public protocol Parameter {
    var value: Int { get }
}

extension FixedRatioParameter: Parameter {}
extension FixedIntervalParameter: Parameter {}
extension FixedTimeParameter: Parameter {}
extension VariableRatioParameter: Parameter {}
extension VariableIntervalParameter: Parameter {}
extension VariableTimeParameter: Parameter {}
extension RandomRatioParameter: Parameter {}
extension RandomIntervalParameter: Parameter {}
extension RandomTimeParameter: Parameter {}
