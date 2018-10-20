//
//  RandomParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public protocol RandomParameter {
    var nextValue: Int { get }
}

// MARK: - Random parameters

extension RandomRatioParameter: RandomParameter {
    init(value: Int) {
        self.value = value
        self.nextValue = RandomGenerator().generatedRatio(value)
    }
}

extension RandomIntervalParameter: RandomParameter {
    init(value: Int) {
        self.value = value
        self.nextValue = RandomGenerator().generatedInterval(value)
    }
}

extension RandomTimeParameter: RandomParameter {
    init(value: Int) {
        self.value = value
        self.nextValue = RandomGenerator().generatedTime(value)
    }
}

