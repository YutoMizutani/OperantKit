//
//  DiscreteTrialDataStoreImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public class DiscreteTrialDataStoreImpl: DiscreteTrialParameter, DiscreteTrialRecordable {
    public var maxTrials: Int
    public var parameters: [TrialParameter]
    public var records: [TrialRecordable]

    public init(maxTrials: Int, parameters: [TrialParameter], records: [TrialRecordable]) {
        self.maxTrials = maxTrials
        self.parameters = parameters
        self.records = records
    }
}
