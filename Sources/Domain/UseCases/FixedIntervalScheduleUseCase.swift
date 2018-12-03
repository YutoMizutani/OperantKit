//
//  FixedIntervalScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

public class FixedIntervalScheduleUseCase: ScheduleUseCaseBase, ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .fixedInterval
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = getCurrentValue(entity)
            .FI(repository.getValue())
            .map { ResultEntity($0, entity) }

        return !isUpdateIfReinforcement ? result : updateValueIfReinforcement(result)
    }
}
