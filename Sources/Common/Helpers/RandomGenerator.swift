//
//  RandomGenerator.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct RandomGenerator {
    public init() {}

    public func generate(_ value: Int) -> Int {
        guard value > 0 else { return 0 }
        return Int.random(in: 1...value)
    }
}
