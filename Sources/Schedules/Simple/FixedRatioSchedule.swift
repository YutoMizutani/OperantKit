//
//  FixedRatioSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Fixed ratio (FR) schedule
public struct FixedRatioSchedule {
    public init() {}

    /// Decision schedule
    public func decision(_ numOfResponses: Int, value: Int) -> Bool {
        return numOfResponses >= value
    }
}
