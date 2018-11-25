//
//  DiscreteTrialRepository.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public protocol DiscreteTrialRepository {
    var parameter: DiscreteTrialParameter { get }
    var recorder: DiscreteTrialRecordable { get set }

    func updateTrialState(_ state: TrialState)
    func getTrialState() -> TrialState
}

public extension DiscreteTrialRepository {
    mutating func updateTrialState(_ state: TrialState) {
        recorder.trialState = state
    }

    func getTrialState() -> TrialState {
        return recorder.trialState
    }
}
