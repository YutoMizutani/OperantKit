//
//  FixedTimeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public class FixedTimeScheduleUseCase: ScheduleUseCaseBase, ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .fixedTime
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = getCurrentValue(entity)
            .FT(repository.getValue())
            .map { ResultEntity($0, entity) }

        return !isUpdateIfReinforcement ? result : updateValueIfReinforcement(result)
    }
}
