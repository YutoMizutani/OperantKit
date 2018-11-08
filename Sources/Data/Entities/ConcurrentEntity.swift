//
//  ConcurrentEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/07.
//

import Foundation

public class ConcurrentEntity {
    public var subSchedules: [ScheduleUseCase]
    public var isShared: Bool

    public init(subSchedules: [ScheduleUseCase], isShared: Bool) {
        self.subSchedules = subSchedules
        self.isShared = isShared
    }
}
