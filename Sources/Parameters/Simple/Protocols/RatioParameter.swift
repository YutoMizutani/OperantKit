//
//  RatioParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Ratio parameter
public protocol RatioParameter {
    var value: Int { get }
}

// MARK: - Ratio parameters

extension FixedRatioParameter: RatioParameter {}
extension VariableRatioParameter: RatioParameter {}
extension RandomRatioParameter: RatioParameter {}
