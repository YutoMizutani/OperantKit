//
//  ReinforcementSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import Foundation

/**

 e.g.
    public extension ReinforcementSchedule {
        static let YourOwnSchedule = ReinforcementSchedule(rawValue: 0b00000000_00000000_00000000_00000000_0000000000000000_0000000000000000)
    }
 */
public struct ReinforcementSchedule: OptionSet {
    public let rawValue: UInt64

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    // MARK: - Extinction schedule
    public static let Extinction = ReinforcementSchedule(rawValue: 0b00000000_00000000_00000000_00000000_0000000000000000_0000000000000000)

    // MARK: - Ratio schedule
    public static let FixedRatio: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue)
    )
    public static let VariableRatio: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue)
    )
    public static let RandomRatio: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue)
    )

    // MARK: - Interval schedule
    public static let FixedInterval: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue)
    )
    public static let VariableInterval: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue)
    )
    public static let RandomInterval: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue)
    )

    // MARK: - Time schedule
    public static let FixedTime: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue)
    )
    public static let VariableTime: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue)
    )
    public static let RandomTime: ReinforcementSchedule =
        ReinforcementSchedule(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue)
    )
}

public extension ReinforcementSchedule {
    func hasExtensionSchedule() -> Bool {
        return self == ReinforcementSchedule.Extinction
    }

    func hasFixedSchedule() -> Bool {
        return (self.rawValue << 32) >> 48 == UInt64(PrepositionSchedule.FixedSchedule.rawValue)
    }

    func hasVariableSchedule() -> Bool {
        return (self.rawValue << 32) >> 48 == UInt64(PrepositionSchedule.VariableSchedule.rawValue)
    }

    func hasRandomSchedule() -> Bool {
        return (self.rawValue << 32) >> 48 == UInt64(PrepositionSchedule.RandomSchedule.rawValue)
    }

    func hasRatioSchedule() -> Bool {
        return (self.rawValue << 48) >> 48 == UInt64(PostpositionSchedule.RatioSchedule.rawValue)
    }

    func hasIntervalSchedule() -> Bool {
        return (self.rawValue << 48) >> 48 == UInt64(PostpositionSchedule.IntervalSchedule.rawValue)
    }

    func hasTimeSchedule() -> Bool {
        return (self.rawValue << 48) >> 48 == UInt64(PostpositionSchedule.TimeSchedule.rawValue)
    }
}
