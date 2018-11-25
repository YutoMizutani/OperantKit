//
//  DiscreteTrialRepositoryImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public class DiscreteTrialRepositoryImpl: DiscreteTrialRepository {
    public var parameter: DiscreteTrialParameter
    public var recorder: DiscreteTrialRecordable

    public init(parameter: DiscreteTrialParameter, recorder: DiscreteTrialRecordable) {
        self.parameter = parameter
        self.recorder = recorder
    }

    public init(dataStore: DiscreteTrialDataStoreImpl) {
        self.parameter = dataStore
        self.recorder = dataStore
    }

    public func updateTrialState(_ state: TrialState) {
        recorder.trialState = state
    }

    public func getTrialState() -> TrialState {
        return recorder.trialState
    }
}
