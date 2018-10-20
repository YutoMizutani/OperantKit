//
//  TimeParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Time parameter
public protocol TimeParameter {
    var value: Int { get }
}

// MARK: - Time parameters

extension FixedTimeParameter: TimeParameter {}
extension VariableTimeParameter: TimeParameter {}
extension RandomTimeParameter: TimeParameter {}
