//
//  UInt64+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/19.
//

import Foundation

public extension UInt64 {
    /// A nanoseconds value of translated from `mach_absolute_time()`
    var nanoseconds: UInt64 {
        return self * TimeHelper.shared.numer / TimeHelper.shared.denom
    }

    /// A milliseconds value of translated from `mach_absolute_time()`
    var milliseconds: Milliseconds {
        return Milliseconds(nanoseconds / 1_000_000)
    }
}
