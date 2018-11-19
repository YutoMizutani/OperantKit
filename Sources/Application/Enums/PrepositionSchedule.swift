//
//  PrepositionSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import Foundation

public struct PrepositionSchedule: OptionSet {
    public let rawValue: UInt16

    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    public static let FixedSchedule = PrepositionSchedule(rawValue: 1 << 0)
    public static let VariableSchedule = PrepositionSchedule(rawValue: 1 << 1)
    public static let RandomSchedule = PrepositionSchedule(rawValue: 1 << 2)
}
