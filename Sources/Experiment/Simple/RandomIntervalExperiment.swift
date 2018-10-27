//
//  RandomIntervalExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct RandomIntervalExperiment: Experiment {
    public typealias Schedulable = RandomIntervalSchedule
    public typealias Parameterable = RandomIntervalParameter
    public typealias Stateable = RandomIntervalState

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
