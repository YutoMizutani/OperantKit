//
//  ConcurrentResponseDataStore.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/07.
//

import Foundation

public struct ConcurrentResponseDataStore {
    public var concurrentEntity: ConcurrentEntity

    public init(subSchedules: [ScheduleUseCase], isShared: Bool) {
        self.concurrentEntity = ConcurrentEntity(subSchedules: subSchedules, isShared: isShared)
    }

    public init(concurrentEntity: ConcurrentEntity) {
        self.concurrentEntity = concurrentEntity
    }
}
