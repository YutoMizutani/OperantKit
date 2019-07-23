//
//  ExtinctionScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public class ExtinctionScheduleUseCase: ScheduleUseCaseBase, ScheduleUseCase {
    public var scheduleType: ScheduleType {
        return .extinction
    }

    // TODO: Update

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        return getCurrentValue(entity)
//            .EXT()
            .map { ResultEntity(false, $0) }
    }
}
