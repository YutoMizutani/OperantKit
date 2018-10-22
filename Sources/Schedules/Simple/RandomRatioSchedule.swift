//
//  RandomRatioSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Random ratio (RR) schedule
public struct RandomRatioSchedule {
    public init() {}

    /// Decision schedule
    public func decision(_ numOfResponses: Int, value: Int) -> Bool {
        return numOfResponses >= value
    }
}
