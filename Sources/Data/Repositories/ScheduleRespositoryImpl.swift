//
//  ScheduleRespositoryImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public struct ScheduleRespositoryImpl: ScheduleRespository {
    public var parameter: ScheduleParameterable
    public var recorder: ScheduleRecordable
    public var logger: Loggable

    public init(parameter: ScheduleParameterable,
                recorder: ScheduleRecordable,
                logger: Loggable) {
        self.parameter = parameter
        self.recorder = recorder
        self.logger = logger
    }

    public init(dataStore: ScheduleParameterable & ScheduleRecordable,
                logger: Loggable) {
        self.parameter = dataStore
        self.recorder = dataStore
        self.logger = logger
    }

    public init(dataStore: ScheduleParameterable & ScheduleRecordable & Loggable) {
        self.parameter = dataStore
        self.recorder = dataStore
        self.logger = dataStore
    }

    public init(parameters: [Parameter]) {
        let dataStore = ScheduleDataStore(parameters: parameters)
        self.init(dataStore: dataStore)
    }

    public init(parameter: Parameter) {
        let dataStore = ScheduleDataStore(parameters: [parameter])
        self.init(dataStore: dataStore)
    }

    public init() {
        let dataStore = ScheduleDataStore(parameters: [Parameter.empty])
        self.init(dataStore: dataStore)
    }

    public init(value: Int) {
        let dataStore = ScheduleDataStore(parameters: [Parameter(value)])
        self.init(dataStore: dataStore)
    }

    public init(value: Int, values: [Int]) {
        let dataStore = ScheduleDataStore(parameters: [Parameter.variable(value, values: values)])
        self.init(dataStore: dataStore)
    }

    public init(value: Int, type: ParameterType) {
        let dataStore = ScheduleDataStore(parameters: [Parameter(value, type: type)])
        self.init(dataStore: dataStore)
    }

    public init(parameters: [(value: Int, type: ParameterType)]) {
        let dataStore = ScheduleDataStore(parameters: parameters.map { Parameter($0.value, type: $0.type) })
        self.init(dataStore: dataStore)
    }
}
