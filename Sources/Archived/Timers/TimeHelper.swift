//
//  TimeHelper.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/19.
//

import Foundation

public struct TimeHelper {
    public static let shared = TimeHelper()
    public let numer: UInt64
    public let denom: UInt64

    private init() {
        var info = mach_timebase_info(numer: 0, denom: 0)
        mach_timebase_info(&info)
        numer = UInt64(info.numer)
        denom = UInt64(info.denom)
    }
}
