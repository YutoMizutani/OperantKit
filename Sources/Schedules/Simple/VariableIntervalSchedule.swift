//
//  VariableIntervalSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Variable interval (VI) schedule
public struct VariableIntervalSchedule {
    /// Decision schedule
    func decision(_ elapsedTime: Int, value: Int) -> Bool {
        return elapsedTime >= value
    }
}
