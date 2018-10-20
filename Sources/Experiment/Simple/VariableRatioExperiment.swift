//
//  VariableRatioExperiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

public struct VariableRatioExperiment {
    public internal(set) var schedule: VariableRatioSchedule
    public internal(set) var parameter: VariableRatioParameter
    public internal(set) var state: VariableRatioState
}
