//
//  ScheduleRespositoryImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public class ScheduleRespositoryImpl: ScheduleRespository {
    public var parameter: ScheduleParameterable
    public var recorder: (ScheduleRecordable & ExperimentRecordable)

    public init(parameter: ScheduleParameterable,
                recorder: ScheduleRecordable & ExperimentRecordable) {
        self.parameter = parameter
        self.recorder = recorder
    }

    public init(dataStore: ScheduleParameterable & ScheduleRecordable & ExperimentRecordable) {
        self.parameter = dataStore
        self.recorder = dataStore
    }
}

public extension ScheduleRespositoryImpl {
    convenience init() {
        let dataStore = ScheduleDataStoreImpl(value: 0, values: [])
        self.init(dataStore: dataStore)
    }

    convenience init(value: Int, values: [Int]) {
        let dataStore = ScheduleDataStoreImpl(value: value, values: values)
        self.init(dataStore: dataStore)
    }

    convenience init(value: Int, values: [Int], initValue: Int) {
        let dataStore = ScheduleDataStoreImpl(value: value, values: values, initValue: initValue)
        self.init(dataStore: dataStore)
    }
}
