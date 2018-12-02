//
//  AlternativeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public struct AlternativeScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository
    public var subSchedules: [ScheduleUseCase]

    public init(_ subSchedules: ScheduleUseCase..., repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public init(_ subSchedules: [ScheduleUseCase], repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result: Single<ResultEntity> = (isUpdateIfReinforcement ? repository.updateEmaxEntity(entity) : Single.just(()))
            .flatMap {
                Observable.zip(
                    self.subSchedules.map { $0.decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement).asObservable() }
                )
            }
            .map { ResultEntity(!$0.filter({ $0.isReinforcement }).isEmpty, entity) }

        return !isUpdateIfReinforcement
            ? result
            : Single.zip(result, repository.getMaxEntity())
                .flatMap {
                    guard $0.0.isReinforcement else { return Single.just($0.0) }
                    return self.updateValue(ResultEntity($0.0.isReinforcement, $0.1))
                }
    }

    public func updateValue(_ result: ResultEntity) -> Single<ResultEntity> {
        return Observable.zip(
                subSchedules.map { $0.updateValue(result).asObservable() }
            )
            .map { _ in result }
            .asSingle()
    }
}
