//
//  VariableTimeExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct VariableTimeExperiment: Experiment {
    public typealias Schedulable = VariableTimeSchedule
    public typealias Parameterable = VariableTimeParameter
    public typealias Stateable = VariableTimeState

    public var schedule: Schedulable
    public var parameter: Parameterable
    public var state: Stateable
}
