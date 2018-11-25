//
//  DiscreteTrialDataStoreImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public class DiscreteTrialDataStoreImpl: DiscreteTrialParameter, DiscreteTrialRecordable {
    public var maxTrials: Int
    public var records: [TrialRecordable]
    public var trialState: TrialState

    public init(maxTrials: Int, records: [TrialRecordable] = [], trialState: TrialState = .prepare) {
        self.maxTrials = maxTrials
        self.records = records
        self.trialState = trialState
    }
}
