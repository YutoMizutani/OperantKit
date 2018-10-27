//
//  RandomTimeParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct RandomTimeParameter {
    public var value: Int
    public internal(set) var nextValue: Int

    public init(value: Int, nextValue: Int) {
        self.value = value
        self.nextValue = nextValue
    }
}
