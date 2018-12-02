//
//  FixedIntervalScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

public struct FixedIntervalScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository

    public var scheduleType: ScheduleType {
        return .fixedInterval
    }

    public init(repository: ScheduleRespository) {
        self.repository = repository
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = Single.zip(
                repository.updateEmaxEntity(entity),
                repository.getExtendEntity(),
                repository.getLastReinforcement()
            )
            .map { (entity - $0.1 - $0.2) }
            .FI(repository.getValue())
            .map { ResultEntity($0, entity) }

        return !isUpdateIfReinforcement ? result : result
            .flatMap {
                $0.isReinforcement
                    ? self.updateValue($0)
                    : Single.just($0)
            }
    }
}
