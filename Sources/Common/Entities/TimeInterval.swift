//
//  TimeInterval.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/22.
//

import Foundation

public enum TimeInterval: Equatable {
    case hours(Int)
    case minutes(Int)
    case seconds(Int)
    case milliseconds(Int)

    public static func == (lhs: TimeInterval, rhs: TimeInterval) -> Bool {
        return true
    }
}

public extension TimeInterval {
    /// Long name
    var longName: String {
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
    var shortName: String {
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

    /// Translate to hours unit
    var hours: Hours? {
        switch self {
        case .hours(let value):
            return value
        case .minutes(let value):
            return value % 60 == 0 ? value / 60 : nil
        case .seconds(let value):
            return value % (60 * 60) == 0 ? value / (60 * 60) : nil
        case .milliseconds(let value):
            return value % (1000 * 60 * 60) == 0 ? value / (1000 * 60 * 60) : nil
        }
    }

    /// Translate to minutes unit
    var minutes: Minutes? {
        switch self {
        case .hours(let value):
            return value * 60
        case .minutes(let value):
            return value
        case .seconds(let value):
            return value % 60 == 0 ? value / 60 : nil
        case .milliseconds(let value):
            return value % (1000 * 60) == 0 ? value / (1000 * 60) : nil
        }
    }

    /// Translate to seconds unit
    var seconds: Seconds? {
        switch self {
        case .hours(let value):
            return value * 60 * 60
        case .minutes(let value):
            return value * 60
        case .seconds(let value):
            return value
        case .milliseconds(let value):
            return value % 1000 == 0 ? value / 1000 : nil
        }
    }

    /// Translate to milliseconds unit
    var milliseconds: Milliseconds {
        switch self {
        case .hours(let value):
            return value * 60 * 60 * 1000
        case .minutes(let value):
            return value * 60 * 1000
        case .seconds(let value):
            return value * 1000
        case .milliseconds(let value):
            return value
        }
    }
}

import RxSwift

public extension TimeInterval {
    func toRxTimeInterval() -> RxTimeInterval {
        return RxTimeInterval.milliseconds(milliseconds)
    }
}
