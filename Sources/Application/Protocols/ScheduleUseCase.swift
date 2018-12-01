//
//  ScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

/// - Tag: ScheduleUseCase
public protocol ScheduleUseCase {
    var repository: ScheduleRespository { get }

    /// Decision the reinforcement schedule
    func decision(_ entity: ResponseEntity) -> Single<ResultEntity>
    func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity>
    func updateValue() -> Single<Void>
    func updateValue(_ result: ResultEntity) -> Single<ResultEntity>
}

public extension ScheduleUseCase {
    func decision(_ entity: ResponseEntity) -> Single<ResultEntity> {
        return decision(entity, isUpdateIfReinforcement: true)
    }

    func updateValue() -> Single<Void> {
        return Single.zip(
            self.repository.resetExtendEntity(),
            self.repository.updateLastReinforcement(),
            self.repository.nextValue()
            )
            .map { _ in }
    }

    func updateValue(_ result: ResultEntity) -> Single<ResultEntity> {
        return Single.zip(
            self.repository.resetExtendEntity(),
            self.repository.updateLastReinforcement(result.entity),
            self.repository.nextValue()
            )
            .map { _ in result }
    }
}
