//
//  FixedTimeExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct FixedTimeExperiment {
    public internal(set) var schedule: FixedTimeSchedule
    public internal(set) var parameter: FixedTimeParameter
    public internal(set) var state: FixedTimeState
}
