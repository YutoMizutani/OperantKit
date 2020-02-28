//
//  ConcurrentScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/07.
//

import RxSwift

public struct ConcurrentScheduleUseCase {
    public var dataStore: ConcurrentResponseDataStore

    public init(subSchedules: [ScheduleUseCase], isShared: Bool = false) {
        self.dataStore = ConcurrentResponseDataStore(subSchedules: subSchedules, isShared: isShared)
    }

    public init(dataStore: ConcurrentResponseDataStore) {
        self.dataStore = dataStore
    }
}

public extension ConcurrentScheduleUseCase {
    func extendEntity(_ number: Int) -> ResponseEntity {
        let number = dataStore.concurrentEntity.isShared ? 0 : number
        return dataStore.concurrentEntity.subSchedules[number].extendEntity
    }

    func decision(_ observer: Observable<ResponseEntity>, number: Int) -> Observable<ReinforcementResult> {
        let number = dataStore.concurrentEntity.isShared ? 0 : number
        return dataStore.concurrentEntity.subSchedules[number].decision(observer)
    }
}
