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

    public func decision(_ entity: ResponseEntity, index: Int,
                         isUpdateIfReinforcement: Bool = true,
                         isSharedUpdate: Bool = true) -> Single<ResultEntity> {
        guard isShared || subSchedules.count > index else { return Single<ResultEntity>.error(RxError.noElements) }
        let result = subSchedules[isShared ? 0 : index].decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
        return !isSharedUpdate
            ? result
            : result
                .flatMap { result in
                    !result.isReinforcement
                        ? Single.just(result)
                        : Single.zip(self.subSchedules.map { $0.repository.getMaxEntity() })
                            .flatMap { e in
                                Single.zip(
                                    self.subSchedules.enumerated().map {
                                        $0.element.updateValue(
                                            ResultEntity(result.isReinforcement,
                                                         ResponseEntity(e[$0.offset].numOfResponses, result.entity.milliseconds))
                                        )
                                    }
                                )
                            }
                            .map { _ in result }
                }
    }

    public func updateValue(_ result: ResultEntity) -> Single<ResultEntity> {
        guard !subSchedules.isEmpty else { return Single<ResultEntity>.error(RxError.noElements) }
        return Single.zip(subSchedules.map { $0.updateValue(result) }).map { $0[0] }
    }

    public func updateValue(_ result: ResultEntity, index: Int) -> Single<ResultEntity> {
        guard isShared || subSchedules.count > index else { return Single<ResultEntity>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : index].updateValue(result)
    }
}

public extension ConcurrentScheduleUseCase {
    init(repository: ScheduleRespository, sharedSchedule: Shared<ScheduleUseCase>) {
        self.repository = repository
        self.subSchedules = [sharedSchedule.element]
        self.isShared = true
    }
}
