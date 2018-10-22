//
//  FixedRatioExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct FixedRatioExperiment: Experiment {
    public typealias Schedulable = FixedRatioSchedule
    public typealias Parameterable = FixedRatioParameter
    public typealias Stateable = FixedRatioState

    public var schedule: Schedulable
    public var parameter: Parameterable
    public var state: Stateable

    public init(schedule: Schedulable,
                parameter: Parameterable,
                state: Stateable) {
        self.schedule = schedule
        self.parameter = parameter
        self.state = state
    }
}
