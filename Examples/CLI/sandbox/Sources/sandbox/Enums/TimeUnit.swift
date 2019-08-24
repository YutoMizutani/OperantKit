//
//  TimeUnit.swift
//  sandbox
//
//  Created by Yuto Mizutani on 2019/08/04.
//

import OperantKit

/// Time unit
public enum TimeUnit: CaseIterable {
    case hours, minutes, seconds, milliseconds
}

extension TimeUnit {
    /// Long name
    public var longName: String {
        switch self {
        case .hours:
            return "Hours"
        case .minutes:
            return "Minutes"
        case .seconds:
            return "Seconds"
        case .milliseconds:
            return "Milliseconds"
        }
    }

    /// Short name
    public var shortName: String {
        switch self {
        case .hours:
            return "hr"
        case .minutes:
            return "m"
        case .seconds:
            return "s"
        case .milliseconds:
            return "ms"
        }
    }

    /// Translate to OperantKit.TimeInterval
    public func timeInterval(_ value: Int) -> OperantKit.TimeInterval {
        switch self {
        case .hours:
            return TimeInterval.hours(value)
        case .minutes:
            return TimeInterval.minutes(value)
        case .seconds:
            return TimeInterval.seconds(value)
        case .milliseconds:
            return TimeInterval.milliseconds(value)
        }
    }
}
