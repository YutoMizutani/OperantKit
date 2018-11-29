//
//  PostpositionSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import Foundation

public struct PostpositionSchedule: OptionSet {
    /// The raw value of the option set
    public let rawValue: UInt16

    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    public static let RatioSchedule = PostpositionSchedule(rawValue: 1 << 0)
    public static let IntervalSchedule = PostpositionSchedule(rawValue: 1 << 1)
    public static let TimeSchedule = PostpositionSchedule(rawValue: 1 << 2)
}
