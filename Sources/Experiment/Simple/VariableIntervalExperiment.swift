//
//  VariableIntervalExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct VariableIntervalExperiment: Experiment {
    public typealias Schedulable = VariableIntervalSchedule
    public typealias Parameterable = VariableIntervalParameter
    public typealias Stateable = VariableIntervalState

    public var schedule: Schedulable
    public var parameter: Parameterable
    public var state: Stateable
}
