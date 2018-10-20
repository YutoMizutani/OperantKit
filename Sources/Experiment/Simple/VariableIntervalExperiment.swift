//
//  VariableIntervalExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct VariableIntervalExperiment {
    public internal(set) var schedule: VariableIntervalSchedule
    public internal(set) var parameter: VariableIntervalParameter
    public internal(set) var state: VariableIntervalState
}
