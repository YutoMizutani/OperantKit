//
//  PrepositionSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import Foundation

public struct PrepositionSchedule: OptionSet {
    /// The raw value of the option set
    public let rawValue: UInt16

    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    public static let fixedSchedule = PrepositionSchedule(rawValue: 1 << 0)
    public static let variableSchedule = PrepositionSchedule(rawValue: 1 << 1)
    public static let randomSchedule = PrepositionSchedule(rawValue: 1 << 2)
}
