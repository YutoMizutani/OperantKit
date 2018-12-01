//
//  ScheduleDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import Foundation

public class ScheduleDataStore: Loggable, ScheduleParameterable, ScheduleRecordable {
    public var parameters: [Parameter]
    public var scheduleRecordEntities: [ScheduleRecordEntity]
    public var logs: [LogType]

    public init(parameters: [Parameter],
                scheduleRecordEntities: [ScheduleRecordEntity] = [],
                logs: [LogType] = []) {
        self.parameters = parameters
        self.scheduleRecordEntities = scheduleRecordEntities.isEmpty
            ? [ScheduleRecordEntity](repeating: ScheduleRecordEntity.zero, count: parameters.count)
            : scheduleRecordEntities
        self.logs = logs.isEmpty ? [] : logs
    }
}
