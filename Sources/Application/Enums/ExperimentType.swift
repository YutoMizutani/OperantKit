//
//  ExperimentType.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/19.
//

import Foundation

/// Experiment type
public struct ExperimentType: OptionSet {
    public var rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    /// Discrete trial procedure
    public static let discreteTrial = ExperimentType(rawValue: 0)
    /// Continuous free-operant procedure
    public static let freeOperant = ExperimentType(rawValue: 1)
}
