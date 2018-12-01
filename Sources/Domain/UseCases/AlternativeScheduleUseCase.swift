//
//  AlternativeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public class AlternativeScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository
    public var subSchedules: [ScheduleUseCase]
    var max: ResponseEntity = ResponseEntity.zero

    public init(_ subSchedules: ScheduleUseCase..., repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public init(_ subSchedules: [ScheduleUseCase], repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        max = max.emax(entity)
        let result = Observable.zip(
                subSchedules.map { $0.decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement).asObservable() }
            )
            .map { ResultEntity(!$0.filter({ $0.isReinforcement }).isEmpty, entity) }
            .asSingle()

        return !isUpdateIfReinforcement ? result : result
            .flatMap { [weak self] in
                guard let self = self, $0.isReinforcement else { return Single.just($0) }
                return self.updateValue(ResultEntity($0.isReinforcement, self.max))
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
