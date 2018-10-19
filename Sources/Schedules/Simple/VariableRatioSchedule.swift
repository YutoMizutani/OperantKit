//
//  VariableRatioSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Variable ratio (VR) schedule
public struct VariableRatioSchedule {
    /// Decision schedule
    func decision(_ numOfResponses: Int, value: Int) -> Bool {
        return numOfResponses >= value
    }
}
