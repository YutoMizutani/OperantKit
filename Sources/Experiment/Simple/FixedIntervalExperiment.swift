//
//  FixedIntervalExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct FixedIntervalExperiment {
    public internal(set) var schedule: FixedIntervalSchedule
    public internal(set) var parameter: FixedIntervalParameter
    public internal(set) var state: FixedIntervalState
}
