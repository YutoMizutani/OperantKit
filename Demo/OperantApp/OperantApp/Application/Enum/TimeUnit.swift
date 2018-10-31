//
//  TimeUnit.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/31.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
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
            return value * 60
        case .minutes:
            return value * 60 * 60
        case .hours:
            return value * 60 * 60 * 60
        }
    }
}
