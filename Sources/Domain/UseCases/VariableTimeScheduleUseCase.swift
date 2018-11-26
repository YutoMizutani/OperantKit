//
//  VariableTimeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public struct VariableTimeScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository

    public var scheduleType: ScheduleType {
        return .variableTime
    }

    public init(repository: ScheduleRespository) {
        self.repository = repository
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        let result = Observable.zip(
                repository.getExtendProperty().asObservable(),
                repository.getLastReinforcementProperty().asObservable()
            )
            .map { (entity - $0.0 - $0.1) }
            .VT(repository.getValue())
            .map { ResultEntity($0, entity) }
            .asSingle()

        return !isUpdateIfReinforcement ? result : result
            .flatMap {
                $0.isReinforcement
                    ? self.updateValue($0)
                    : Single.just($0)
            }
    }
}
