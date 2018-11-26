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

    public var scheduleType: ScheduleType {
        return ScheduleType(
            rawValue: UInt64.max,
            shortName: "Alt(\(subSchedules.map { $0.scheduleType.shortName }.joined(separator: ", ")))",
            longName: "Alternative(\(subSchedules.map { $0.scheduleType.longName }.joined(separator: ", ")))"
        )
    }

    public init(_ subSchedules: ScheduleUseCase..., repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public init(_ subSchedules: [ScheduleUseCase], repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = Observable.zip(
                subSchedules.map { $0.decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement).asObservable() }
            )
            .map { ResultEntity(!$0.filter({ $0.isReinforcement }).isEmpty, entity) }
            .asSingle()

        return !isUpdateIfReinforcement ? result : result
            .flatMap {
                guard $0.isReinforcement else { return Single.just($0) }
                return self.updateValue($0)
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
