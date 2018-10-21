//
//  RandomRatioExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct RandomRatioExperiment: Experiment {
    public typealias Schedulable = RandomRatioSchedule
    public typealias Parameterable = RandomRatioParameter
    public typealias Stateable = RandomRatioState

    public var schedule: Schedulable
    public var parameter: Parameterable
    public var state: Stateable
}
