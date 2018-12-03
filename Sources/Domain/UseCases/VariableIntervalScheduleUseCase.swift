//
//  VariableIntervalScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/03.
//

import RxSwift

public class VariableIntervalScheduleUseCase: ScheduleUseCaseBase, ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .variableInterval
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = getCurrentValue(entity)
            .VI(repository.getValue())
            .map { ResultEntity($0, entity) }

        return !isUpdateIfReinforcement ? result : updateValueIfReinforcement(result)
    }
}
