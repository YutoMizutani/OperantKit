//
//  ConcurrentScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/07.
//

import RxSwift

public struct ConcurrentScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository
    public var subSchedules: [ScheduleUseCase]
    public var isShared: Bool
    public var scheduleType: ScheduleType = ScheduleType(rawValue: UInt64.max)

    public init(repository: ScheduleRespository, subSchedules: ScheduleUseCase..., isShared: Bool = false) {
        self.repository = repository
        self.subSchedules = subSchedules
        self.isShared = isShared
    }

    public init(repository: ScheduleRespository, subSchedules: [ScheduleUseCase]) {
        self.repository = repository
        self.subSchedules = subSchedules
        self.isShared = false
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        guard !subSchedules.isEmpty else { return Single<ResultEntity>.error(RxError.noElements) }
        return subSchedules[0].decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
    }

    public func updateValue(_ result: ResultEntity) -> Single<ResultEntity> {
        guard !subSchedules.isEmpty else { return Single<ResultEntity>.error(RxError.noElements) }
        return subSchedules[0].updateValue(result)
    }

    public func decision(_ entity: ResponseEntity, order: Int, isUpdateIfReinforcement: Bool = true) -> Single<ResultEntity> {
        guard isShared || subSchedules.count > order else { return Single<ResultEntity>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : order].decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
    }

    public func updateValue(_ result: ResultEntity, order: Int) -> Single<ResultEntity> {
        guard isShared || subSchedules.count > order else { return Single<ResultEntity>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : order].updateValue(result)
    }
}

public extension ConcurrentScheduleUseCase {
    init(repository: ScheduleRespository, sharedSchedule: Shared<ScheduleUseCase>) {
        self.repository = repository
        self.subSchedules = [sharedSchedule.element]
        self.isShared = true
    }
}
