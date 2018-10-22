//
//  InterlockingSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Interlocking (Interlock) schedule
public struct InterlockingSchedule {
    public init() {}

    /// Decision schedule
    public func decision(_ response: Int,
                         _ time: Int,
                         next: (response: Int, time: Int)
        ) -> Bool {
        guard response < next.response || time < next.time else { return true }
        return response > next.response - time / (next.time / next.response)
    }
}
