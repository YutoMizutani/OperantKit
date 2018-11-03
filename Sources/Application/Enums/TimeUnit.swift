//
//  TimeUnit.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import Foundation

public enum TimeUnit {
    case milliseconds, seconds, minutes, hours
}

public extension TimeUnit {
    func milliseconds(_ value: Int) -> Int {
        switch self {
        case .milliseconds:
            return value
        case .seconds:
            return value * 1000
        case .minutes:
            return value * 1000 * 60
        case .hours:
            return value * 1000 * 60 * 60
        }
    }
}
