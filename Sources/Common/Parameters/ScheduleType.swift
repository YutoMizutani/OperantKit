//
//  ScheduleType.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import Foundation

/**

 e.g.
    public extension ScheduleTypes {
        static let YourOwnSchedule = ScheduleType(rawValue: 0b00000000_00000000_00000000_00000000_0000000000000000_0000000000000000)
    }
 */
public struct ScheduleType: OptionSet {
    public let rawValue: UInt64

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    // MARK: - Extinction schedule
    public static let extinction = ScheduleType(rawValue: 0b00000000_00000000_00000000_00000000_0000000000000000_0000000000000000)

    // MARK: - Ratio schedule
    public static let fixedRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue)
    )
    public static let variableRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue)
    )
    public static let randomRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue)
    )

    // MARK: - Interval schedule
    public static let fixedInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue)
    )
    public static let variableInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue)
    )
    public static let randomInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue)
    )

    // MARK: - Time schedule
    public static let fixedTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue)
    )
    public static let variableTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue)
    )
    public static let randomTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue)
    )
}

public extension ScheduleType {
    func hasExtensionSchedule() -> Bool {
        return self == ScheduleType.extinction
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
