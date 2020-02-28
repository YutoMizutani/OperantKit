//
//  ConcurrentScheduleUseCase+Shared.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/08.
//

import Foundation

public extension ConcurrentScheduleUseCase {
    init(_ sharedSchedule: Shared<ScheduleUseCase>) {
        self.init(subSchedules: [sharedSchedule.element], isShared: true)
    }
}
