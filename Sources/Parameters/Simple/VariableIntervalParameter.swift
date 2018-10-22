//
//  VariableIntervalParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct VariableIntervalParameter {
    public var value: Int
    public var iterations: Int
    public internal(set) var values: [Int]

    public init(value: Int, iterations: Int, values: [Int]) {
        self.value = value
        self.iterations = iterations
        self.values = values
    }
}
