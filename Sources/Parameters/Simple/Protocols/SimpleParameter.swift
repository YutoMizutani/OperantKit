//
//  SimpleParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Simple parameter
public protocol SimpleParameter {
    var value: Int { get }
}

// MARK: - Simple parameters

extension FixedRatioParameter: SimpleParameter {}
extension FixedIntervalParameter: SimpleParameter {}
extension FixedTimeParameter: SimpleParameter {}
extension VariableRatioParameter: SimpleParameter {}
extension VariableIntervalParameter: SimpleParameter {}
extension VariableTimeParameter: SimpleParameter {}
extension RandomRatioParameter: SimpleParameter {}
extension RandomIntervalParameter: SimpleParameter {}
extension RandomTimeParameter: SimpleParameter {}
