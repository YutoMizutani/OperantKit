//
//  AlternativeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public class AlternativeScheduleUseCase: CompoundScheduleUseCaseBase, ScheduleUseCase {

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result: Single<ResultEntity> = Single.zip(subSchedules.map { $0.decision(entity, isUpdateIfReinforcement: false) })
            .map { ResultEntity(!$0.filter({ $0.isReinforcement }).isEmpty, entity) }

        return !isUpdateIfReinforcement ? result : updateValueIfReinforcement(result)
    }
}
