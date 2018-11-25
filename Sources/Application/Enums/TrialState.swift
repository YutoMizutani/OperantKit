//
//  TrialState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/25.
//

import Foundation

/// Trial state
public struct TrialState: OptionSet {
    public var rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static let prepare = TrialState(rawValue: 0)
    public static let didReinforcement = TrialState(rawValue: 1)
}
