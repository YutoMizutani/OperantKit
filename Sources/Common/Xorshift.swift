//
//  Xorshift.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Marsaglia, G. (2003). Xorshift rngs. Journal of Statistical Software, 8(14), 1-6.
open class Xorshift32 {
    private var y: UInt32

    public init(_ seed: UInt32 = 2463534242) {
        self.y = seed
    }

    open func xor32() -> UInt32 {
        y ^= (y << 13)
        y = (y >> 17)
        y ^= (y << 5)
        return y
    }
}

/// Marsaglia, G. (2003). Xorshift rngs. Journal of Statistical Software, 8(14), 1-6.
open class Xorshift64 {
    private var x: UInt64

    public init(_ seed: UInt64 = 88172645463325252) {
        self.x = seed
    }

    open func xor64() -> UInt64 {
        x ^= (x << 13)
        x ^= (x >> 7)
        x ^= (x << 17)
        return x
    }
}

/// Marsaglia, G. (2003). Xorshift rngs. Journal of Statistical Software, 8(14), 1-6.
open class Xorshift128 {
    private var x, y, z, w: UInt64

    public init(x: UInt64 = 123456789, y: UInt64 = 362436069, z: UInt64 = 521288629, w: UInt64 = 88675123) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    public init(_ seed: UInt64 = 123456789) {
        self.x = Xorshift64(seed).xor64()
        self.y = 362436069
        self.z = 521288629
        self.w = 88675123
    }

    open func xor128() -> UInt64 {
        let t: UInt64
        t = x ^ (x << 11)
        x = y; y = z; z = w
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        return w
    }
}
