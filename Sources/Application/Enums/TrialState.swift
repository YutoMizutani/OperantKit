//
//  TrialState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/25.
//

import Foundation

/// Trial state
public struct TrialState: OptionSet, Equatable {
    /// The raw value of the option set
    public var rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    /// Ready for the trial
    public static let ready = TrialState(rawValue: 0)
    /// The trial occured reinforcement
    public static let didReinforcement = TrialState(rawValue: 1)
}
