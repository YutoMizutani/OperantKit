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
        return .variableRatio
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
            .VR(repository.getValue())
            .map { ResultEntity($0, entity) }

        return !isUpdateIfReinforcement ? result : result
            .flatMap {
                $0.isReinforcement
                    ? self.updateValue($0)
                    : Single.just($0)
            }
    }
}
