//
//  RandomRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

public class RandomRatioScheduleUseCase: ScheduleUseCaseBase, ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .randomRatio
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = getCurrentValue(entity)
            .RR(repository.getValue())
            .map { ResultEntity($0, entity) }

        return !isUpdateIfReinforcement ? result : updateValueIfReinforcement(result)
    }
}
