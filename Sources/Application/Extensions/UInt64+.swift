//
//  UInt64+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/19.
//

import Foundation

public extension UInt64 {
    var nanoseconds: UInt64 {
        return self * TimeHelper.shared.numer / TimeHelper.shared.denom
    }

    var milliseconds: Milliseconds {
        return Milliseconds(self.nanoseconds / 1_000_000)
    }
}
