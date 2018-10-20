//
//  IntervalParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Interval parameter
public protocol IntervalParameter {
    var value: Int { get }
}

// MARK: - Interval parameters

extension FixedIntervalParameter: IntervalParameter {}
extension VariableIntervalParameter: IntervalParameter {}
extension RandomIntervalParameter: IntervalParameter {}
