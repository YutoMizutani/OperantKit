//
//  VariableRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct VariableRatioScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository

    public var scheduleType: ScheduleType {
        return .fixedRatio
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
            .VR(repository.getValue())
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
