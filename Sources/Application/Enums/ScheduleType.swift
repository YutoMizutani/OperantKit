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
    /// The raw value of the option set
    public let rawValue: UInt64
    /// Short name
    public let shortName: String
    /// Long (full) name
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

    /// Fixed ratio
    public static let fixedRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.fixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.ratioSchedule.rawValue),
            shortName: "FR",
            longName: "Fixed ratio"
    )

    /// Variable ratio
    public static let variableRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.variableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.ratioSchedule.rawValue),
            shortName: "VR",
            longName: "Variable ratio"
    )

    /// Random ratio
    public static let randomRatio: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.randomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.ratioSchedule.rawValue),
            shortName: "RR",
            longName: "Random ratio"
    )

    // MARK: - Interval schedule

    /// Fixed interval
    public static let fixedInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.fixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.intervalSchedule.rawValue),
            shortName: "FI",
            longName: "Fixed interval"
    )

    /// Variable interval
    public static let variableInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.variableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.intervalSchedule.rawValue),
            shortName: "VI",
            longName: "Variable interval"
    )

    /// Random interval
    public static let randomInterval: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.randomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.intervalSchedule.rawValue),
            shortName: "RI",
            longName: "Random interval"
    )

    // MARK: - Time schedule

    /// Fixed time
    public static let fixedTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.fixedSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.timeSchedule.rawValue),
            shortName: "FT",
            longName: "Fixed time"
    )

    /// Variable time
    public static let variableTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.variableSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.timeSchedule.rawValue),
            shortName: "VT",
            longName: "Variable time"
    )

    /// Random time
    public static let randomTime: ScheduleType =
        ScheduleType(
            rawValue: UInt64(PrepositionSchedule.randomSchedule.rawValue) << 16 + UInt64(PostpositionSchedule.timeSchedule.rawValue),
            shortName: "RT",
            longName: "Random time"
    )
}

public extension ScheduleType {
    /// A Boolean value indicating whether the element has extinction feature
    func hasExtinctionSchedule() -> Bool {
        return self == ScheduleType.extinction
    }

    /// A Boolean value indicating whether the element has fixed feature
    func hasFixedSchedule() -> Bool {
        return (rawValue << 32) >> 48 == UInt64(PrepositionSchedule.fixedSchedule.rawValue)
    }

    /// A Boolean value indicating whether the element has variable feature
    func hasVariableSchedule() -> Bool {
        return (rawValue << 32) >> 48 == UInt64(PrepositionSchedule.variableSchedule.rawValue)
    }

    /// A Boolean value indicating whether the element has random feature
    func hasRandomSchedule() -> Bool {
        return (rawValue << 32) >> 48 == UInt64(PrepositionSchedule.randomSchedule.rawValue)
    }

    /// A Boolean value indicating whether the element has ratio feature
    func hasRatioSchedule() -> Bool {
        return (rawValue << 48) >> 48 == UInt64(PostpositionSchedule.ratioSchedule.rawValue)
    }

    /// A Boolean value indicating whether the element has interval feature
    func hasIntervalSchedule() -> Bool {
        return (rawValue << 48) >> 48 == UInt64(PostpositionSchedule.intervalSchedule.rawValue)
    }

    /// A Boolean value indicating whether the element has time feature
    func hasTimeSchedule() -> Bool {
        return (rawValue << 48) >> 48 == UInt64(PostpositionSchedule.timeSchedule.rawValue)
    }
}
