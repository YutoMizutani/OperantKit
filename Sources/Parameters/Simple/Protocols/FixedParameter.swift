//
//  FixedParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public protocol FixedParameter {
    var value: Int { get }
}

extension FixedRatioParameter: FixedParameter {}
extension FixedIntervalParameter: FixedParameter {}
extension FixedTimeParameter: FixedParameter {}
