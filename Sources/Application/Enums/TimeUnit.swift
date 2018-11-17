//
//  TimeUnit.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import Foundation

public enum TimeUnit: CaseIterable {
    case hours, minutes, seconds, milliseconds
}

extension TimeUnit: TimeUnitable {
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

    public func hours(_ value: Int) -> Hours? {
        switch self {
        case .hours:
            return value
        case .minutes:
            return value % 60 == 0 ? value / 60 : nil
        case .seconds:
            return value % (60 * 60) == 0 ? value / (60 * 60) : nil
        case .milliseconds:
            return value % (1000 * 60 * 60) == 0 ? value / (1000 * 60 * 60) : nil
        }
    }

    public func minutes(_ value: Int) -> Minutes? {
        switch self {
        case .hours:
            return value * 60
        case .minutes:
            return value
        case .seconds:
            return value % 60 == 0 ? value / 60 : nil
        case .milliseconds:
            return value % (1000 * 60) == 0 ? value / (1000 * 60) : nil
        }
    }

    public func seconds(_ value: Int) -> Seconds? {
        switch self {
        case .hours:
            return value * 60 * 60
        case .minutes:
            return value * 60
        case .seconds:
            return value
        case .milliseconds:
            return value % 1000 == 0 ? value / 1000 : nil
        }
    }

    public func milliseconds(_ value: Int) -> Milliseconds {
        switch self {
        case .hours:
            return value * 60 * 60 * 1000
        case .minutes:
            return value * 60 * 1000
        case .seconds:
            return value * 1000
        case .milliseconds:
            return value
        }
    }
}
