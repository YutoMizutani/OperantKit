//
//  TrialParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol TrialParameter {
    var schedule: ScheduleUseCase { get }
    var exitCondition: ExitCondition { get }
}
