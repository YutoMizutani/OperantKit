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

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool) -> Observable<ResultEntity> {
        guard !subSchedules.isEmpty else { return Observable<ResultEntity>.error(RxError.noElements) }
        return subSchedules[0].decision(observer, isUpdateIfReinforcement: isUpdateIfReinforcement)
    }

    public func updateValue(_ observer: Observable<ResultEntity>) -> Observable<ResultEntity> {
        guard !subSchedules.isEmpty else { return Observable<ResultEntity>.error(RxError.noElements) }
        return subSchedules[0].updateValue(observer)
    }

    public func decision(_ observer: Observable<ResponseEntity>, order: Int, isUpdateIfReinforcement: Bool = true) -> Observable<ResultEntity> {
        guard isShared || subSchedules.count > order else { return Observable<ResultEntity>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : order].decision(observer, isUpdateIfReinforcement: isUpdateIfReinforcement)
    }

    public func updateValue(_ observer: Observable<ResultEntity>, order: Int) -> Observable<ResultEntity> {
        guard isShared || subSchedules.count > order else { return Observable<ResultEntity>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : order].updateValue(observer)
    }
}

public extension ConcurrentScheduleUseCase {
    init(repository: ScheduleRespository, sharedSchedule: Shared<ScheduleUseCase>) {
        self.repository = repository
        self.subSchedules = [sharedSchedule.element]
        self.isShared = true
    }
}
