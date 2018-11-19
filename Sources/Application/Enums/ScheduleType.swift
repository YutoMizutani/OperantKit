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
        static let YourOwnSchedule = ScheduleType(
            rawValue: 0b00000000_00000000_00000000_00000000_0000000000000000_0000000000000000,
            shortName: "",
            longName: ""
        )
    }
 */
public struct ScheduleType: OptionSet {
    public let rawValue: UInt64
    public let shortName: String
    public let longName: String

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
        self.shortName = ""
        self.longName = ""
    }

    public init(rawValue: UInt64, shortName: String, longName: String) {
        self.rawValue = rawValue
        self.shortName = shortName
        self.longName = longName
    }

    // MARK: - Extinction schedule
    public static let extinction = ScheduleType(
        rawValue: 0b00000000_00000000_00000000_00000000_0000000000000000_0000000000000000,
        shortName: "EXT",
        longName: "Extinction"
    )

    // MARK: - Ratio schedule
    public static let fixedRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue),
            shortName: "FR",
            longName: "Fixed ratio"
    )
    public static let variableRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue),
            shortName: "VR",
            longName: "Variable ratio"
    )
    public static let randomRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.RatioSchedule.rawValue),
            shortName: "RR",
            longName: "Random ratio"
    )

    // MARK: - Interval schedule
    public static let fixedInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue),
            shortName: "FI",
            longName: "Fixed interval"
    )
    public static let variableInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue),
            shortName: "VI",
            longName: "Variable interval"
    )
    public static let randomInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.IntervalSchedule.rawValue),
            shortName: "RI",
            longName: "Random interval"
    )

    // MARK: - Time schedule
    public static let fixedTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.FixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue),
            shortName: "FT",
            longName: "Fixed time"
    )
    public static let variableTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.VariableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue),
            shortName: "VT",
            longName: "Variable time"
    )
    public static let randomTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.RandomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.TimeSchedule.rawValue),
            shortName: "RT",
            longName: "Random time"
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
