//
//  VariableTimeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public class VariableTimeScheduleUseCase: ScheduleUseCaseBase, ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .variableTime
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = getCurrentValue(entity)
            .VT(repository.getValue())
            .map { ResultEntity($0, entity) }

        return !isUpdateIfReinforcement ? result : updateValueIfReinforcement(result)
    }
}
