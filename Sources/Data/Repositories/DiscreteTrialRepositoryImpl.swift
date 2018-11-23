//
//  DiscreteTrialRepositoryImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public struct DiscreteTrialRepositoryImpl: DiscreteTrialRepository {
    public var dataStore: DiscreteTrialDataStoreImpl

    public var parameter: DiscreteTrialParameter {
        return dataStore
    }
    public var recorder: DiscreteTrialRecordable {
        set {
            dataStore.records = newValue.records
        }
        get {
            return dataStore
        }
    }

    public init(dataStore: DiscreteTrialDataStoreImpl) {
        self.dataStore = dataStore
    }
}
