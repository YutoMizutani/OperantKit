//
//  VariableParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Variable parameter
public protocol VariableParameter {
    var values: [Int] { get }
}

// MARK: - Variable parameters

extension VariableRatioParameter: VariableParameter {
    init(value: Int, iterations: Int = 12) {
        self.value = value
        self.iterations = iterations
        self.values = FleshlerHoffman().generatedRatio(value: value, iterations: iterations)
    }
}

extension VariableIntervalParameter: VariableParameter {
    init(value: Int, iterations: Int = 12) {
        self.value = value
        self.iterations = iterations
        self.values = FleshlerHoffman().generatedInterval(value: value, iterations: iterations)
    }
}

extension VariableTimeParameter: VariableParameter {
    init(value: Int, iterations: Int = 12) {
        self.value = value
        self.iterations = iterations
        self.values = FleshlerHoffman().generatedInterval(value: value, iterations: iterations)
    }
}
