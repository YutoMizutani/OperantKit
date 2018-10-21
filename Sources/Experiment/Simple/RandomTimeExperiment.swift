//
//  RandomTimeExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct RandomTimeExperiment: Experiment {
    public typealias Schedulable = RandomTimeSchedule
    public typealias Parameterable = RandomTimeParameter
    public typealias Stateable = RandomTimeState

    public var schedule: Schedulable
    public var parameter: Parameterable
    public var state: Stateable
}
